Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022Ab1CWXAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 19:00:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34315 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932889Ab1CWXAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 19:00:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "richard -rw- weinberger" <richard.weinberger@gmail.com>
Subject: Re: Corrupted files after suspend to disk
Date: Thu, 24 Mar 2011 00:00:26 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org
References: <AANLkTinRC1hXvaXDVV5pOA4YyCdXwAjziZsDzm=LuHqK@mail.gmail.com> <201103232322.52485.rjw@sisk.pl> <AANLkTi=UMDZ+78bS-U=Kvp_PYnc_BNHH5EgJnm1nssHP@mail.gmail.com>
In-Reply-To: <AANLkTi=UMDZ+78bS-U=Kvp_PYnc_BNHH5EgJnm1nssHP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103240000.26788.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 23, 2011, richard -rw- weinberger wrote:
> On Wed, Mar 23, 2011 at 11:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, March 23, 2011, richard -rw- weinberger wrote:
> >> On Wed, Mar 23, 2011 at 11:11 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Wednesday, March 23, 2011, richard -rw- weinberger wrote:
> >> >> 2011/3/23 Rafael J. Wysocki <rjw@sisk.pl>:
> >> >> > On Wednesday, March 23, 2011, richard -rw- weinberger wrote:
> >> >> >> Hi,
> >> >> >>
> >> >> >> I'm facing a very strange problem on my netbook (Lenovo Ideapad S10)
> >> >> >> running Linux 2.6.37.4.
> >> >> >> After resuming from s2disk some files are corrupted.
> >> >> >> But when I reboot my netbook everything seems good again.
> >> >> >>
> >> >> >> When I saw the problem the first time the ls command segfaulted always.
> >> >> >> I did a reboot and it worked again.
> >> >> >>
> >> >> >> A few days later zypper crashed. After a reboot it worked again.
> >> >> >> And today ssh crashed. I looked a bit closer and saw it crashed
> >> >> >> somewhere within libcrypto.
> >> >> >> So I made copy libcrypto and rebooted.
> >> >> >> After the reboot ssh worked again but libcrypto and the copy of it hat
> >> >> >> a different sha1 sum!
> >> >> >> WTF?!
> >> >> >>
> >> >> >> Is this a known issue?
> >> >> >
> >> >> > No.
> >> >> >
> >> >> >> dmesgs and config are attached.
> >> >> >>
> >> >> >> The used distribution is openSUSE 11.4 with suspend-0.80.20100129-7.1
> >> >> >> (default from suse).
> >> >> >> I'm using ext3 as root filesystem.
> >> >> >> What else do you need?
> >> >> >
> >> >> > Whatever you can do to narrow down the problem.  At the moment I only know
> >> >> > that it's there.
> >> >>
> >> >> I can reproduce the problem now.
> >> >> After ~20 suspend and resume iterations aide finds corrupted files in /lib/.
> >> >> It's always a very basic lib like libcrypto, libglib which is used all
> >> >> the time on my system.
> >> >
> >> > Those files are never intentionally modified, right?
> >> >
> >> >> Maybe it's an issue like this one?
> >> >> https://lkml.org/lkml/2010/12/2/339
> >> >
> >> > It might have if that patch hadn't been merged before 2.6.37.
> >> >
> >> > Is the system 32-bit or 64-bit?
> >>
> >> It's a 32-bit system.
> >> cmp shows that the corrupted files differ in many bytes (not scattered).
> >> The corrupted bytes are always 0 or 252.
> >
> > Do I understand correctly that the files apparently corrupted after resume
> > are not corrupted any more when you reboot?
> 
> Yes.
> Seems like a cache issue.
 
There's a couple things you can check before we start asking other people for
help.

First, it would be good to know if things change when you save the image
into a swap file instead of the swap partition you've been using so far
(I believe it's documented quite well how to do that).

Second, please verify if using the built-in save/load hibernate code leads
to the same issue (you can hibernate by doing "echo disk > /sys/power/state"
to verify that).

Of course, please test the above separately. :-)

Thanks,
Rafael
