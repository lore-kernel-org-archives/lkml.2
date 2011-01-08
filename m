Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab1AHSBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 13:01:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab1AHSBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 13:01:32 -0500
Date: Sat, 8 Jan 2011 13:01:21 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: kobject_put vs module unload
In-Reply-To: <AANLkTikg7vAG4-E=BD_sC=63R8fDCfEi_wiqnxDnUnK=@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1101081258560.24933@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1101072234040.382@hs20-bc2-1.build.redhat.com>
 <20110108055621.GB10391@suse.de> <Pine.LNX.4.64.1101080811400.29089@hs20-bc2-1.build.redhat.com>
 <AANLkTikg7vAG4-E=BD_sC=63R8fDCfEi_wiqnxDnUnK=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168436252-1971607652-1294509681=:24933"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168436252-1971607652-1294509681=:24933
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 8 Jan 2011, Kay Sievers wrote:

> On Sat, Jan 8, 2011 at 14:19, Mikulas Patocka <mpatocka@redhat.com> wrote=
:
> > On Fri, 7 Jan 2011, Greg KH wrote:
>=20
> >> > 4) the reference obtained at point 1) is dropped, kobject reference =
count
> >> > reaches zero and the release callback is called. But that callback p=
oints
> >> > to an unloaded module and causes a crash.
> >> >
> >> > How is it solved? Am I missing something?
> >>
> >> You have the code that creates and frees the object, to not be in the
> >> module that could have been unloaded. =C2=A0It's really just that simp=
le.
> >
> > If the whole device mapper subsystem can be a module, where can I put t=
he
> > code?
> >
> > I think a similar bug exists in md, it can also be unloaded as a module
> > and it has "release" method in its module code.
>=20
> If you still have data structures hanging around, these structures are
> supposed to take a reference on the module -- and you can not unload
> the module as long as this is the case.
>=20
> Kay

kobject references don't increase module reference count. If kobject held=
=20
module references, it would be a fix for this bug, but could cause other=20
bugs (some modules could be unloadable due to self-references to its own=20
kobjects).

Mikulas
--168436252-1971607652-1294509681=:24933--
