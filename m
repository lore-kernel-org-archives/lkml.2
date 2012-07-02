Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab2GBPv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:51:26 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:53948 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab2GBPvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:51:25 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=5IHOoYxWhOBHBjxRjsytFIaGx6x4TpiPlHbSP8z3ab80WfqmyeTx73e/BcUa
	D6wvOjiDTIOWN2K/Lxn8du9GBS42ycyFgSzTRnZAr16CZXGTNXThl/G6K
	Qm9S49z0HyaqkNWgCwDMh3FO/vw0MCuvP8uwDS1ZTto9bBEIvbOAME=;
X-Spam-Processed: mail.digidescorp.com, Mon, 02 Jul 2012 10:51:22 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1530ba36e9=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1341244281.1695.28.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH] fat: Refactor shortname parsing
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 02 Jul 2012 10:51:21 -0500
In-Reply-To: <871ukunqp3.fsf@devron.myhome.or.jp>
References: <1340993528-12111-1-git-send-email-steve@digidescorp.com>
	 <87r4syrl4y.fsf@devron.myhome.or.jp>
	 <1340997235.9826.7.camel@iscandar.digidescorp.com>
	 <87bok1sx6j.fsf@devron.myhome.or.jp> <87zk7lribe.fsf@devron.myhome.or.jp>
	 <1341234099.1695.13.camel@iscandar.digidescorp.com>
	 <87fw9anuwk.fsf@devron.myhome.or.jp>
	 <1341237638.1695.16.camel@iscandar.digidescorp.com>
	 <8762a6nsao.fsf@devron.myhome.or.jp>
	 <1341240342.1695.20.camel@iscandar.digidescorp.com>
	 <871ukunqp3.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 00:11 +0900, OGAWA Hirofumi wrote: 
> "Steven J. Magnani" <steve@digidescorp.com> writes:
> 
> > On Mon, 2012-07-02 at 23:36 +0900, OGAWA Hirofumi wrote: 
> >> "Steven J. Magnani" <steve@digidescorp.com> writes:
> >> 
> >> > True, but with the change you suggest we lose the incrementing of 'i',
> >> > which likely would cause an infinite loop for 1:1 Unicode conversions.
> >> 
> >> You meant, we just have to do
> >> 
> >> 	if (!is_vfat)
> >>         	ptname[i] = ...;
> >> 	i++;
> >> 
> >> or something? I still feel this looks better to indicate, we don't use
> >> ptname in the case of vfat.
> >
> > I can change it, but there are other places in that function where
> > ptname is used that are not qualified with !is_vfat, so I don't know
> > whether this improves clarity or reduces it.
> >
> > I do think fat_tolower() should not be making decisions. IMHO the
> > trigraph and a comment, perhaps before the vfat-only reassignment of
> > 'name', would be clearer. 
> 
> Hm, the primary case is vfat. fat_tolower()/hidden is required only for
> msdos, and ptname too. So, my suggestion is trying to keep vfat case
> clean.

It's not clear to me where you want to go with this. 

1. Split fat_parse_short() into msdos and vfat versions. This may
improve clarity, but there would be some replication of code.

2. Sprinkle "if (!isvfat)" throughout the already-proposed version of
fat_parse_short()
  A. Everywhere
  B. Only in the places you've proposed

3. Retain the already-proposed version of fat_parse_short(), but add a
comment that the uni_name overrides the msdos "ptname", and separate out
the decision to lowercase from fat_tolower() [i.e., the trigraph].

4. Other options?

The NFS changes I would like to post depend on fat_parse_short() in some
form.

Steve


