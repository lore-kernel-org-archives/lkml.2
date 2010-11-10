Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab0KJB1C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:27:02 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59420 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab0KJB07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:26:59 -0500
Date: Tue, 9 Nov 2010 20:26:53 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@canonical.com>
X-X-Sender: nico@xanadu.home
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 29/49] vcs: add poll/fasync support
In-Reply-To: <AANLkTinVp4C9bRW6=EMHwh1UyeadFbOXKe1aDsxknJf8@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1011092013290.13911@xanadu.home>
References: <20101022175112.GC13489@kroah.com> <1287771688-14805-29-git-send-email-gregkh@suse.de> <AANLkTinVp4C9bRW6=EMHwh1UyeadFbOXKe1aDsxknJf8@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811582-1337357285-1289352415=:13911"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811582-1337357285-1289352415=:13911
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 10 Nov 2010, Kay Sievers wrote:

> On Fri, Oct 22, 2010 at 20:21, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> > From: Nicolas Pitre <nico@fluxnic.net>
> >
> > The /dev/vcs* devices are used, amongst other things, by accessibility
> > applications such as BRLTTY to display the screen content onto refresha=
ble
> > braille displays. =C2=A0Currently this is performed by constantly readi=
ng from
> > /dev/vcsa0 whether or not the screen content has changed. =C2=A0Given t=
he
> > default braille refresh rate of 25 times per second, this easily qualif=
ies
> > as the biggest source of wake-up events preventing laptops from enterin=
g
> > deeper power saving states.
> >
> > To avoid this periodic polling, let's add support for select()/poll() a=
nd
> > SIGIO with the /dev/vcs* devices. =C2=A0The implemented semantic is to =
report
> > data availability whenever the corresponding vt has seen some update af=
ter
> > the last read() operation. =C2=A0The application still has to lseek() b=
ack
> > as usual in order to read() the new data.
>=20
> Shouldn't it raise POLLPRI/POLLERR then, when it's not about new data
> to read? We do this for several files in the kernel where we just want
> to wakup someone, but the pretty well-defined semantics of poll()
> don't apply.

Hmmm...  Maybe POLLPRI, but POLLERR makes no sense.


Nicolas
---1463811582-1337357285-1289352415=:13911--
