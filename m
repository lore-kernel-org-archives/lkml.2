Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab1GMVnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:43:10 -0400
Received: from sous-sol.org ([216.99.217.87]:58023 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750977Ab1GMVnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:43:08 -0400
Date: Wed, 13 Jul 2011 14:42:50 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Stratos Psomadakis <psomas@gentoo.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        David Woodhouse <David.Woodhouse@intel.com>, kernel@gentoo.org
Subject: Re: -stable commit 87cc4d1e (bisected) causes system freeze
Message-ID: <20110713214250.GW15844@sequoia.sous-sol.org>
References: <CAAdZ7YhU=ETCYPhUq-3tB6tgRZ5ZA1fRKuyXT5aZMxU0-0gdFQ@mail.gmail.com>
 <4E1DEA24.3010109@gentoo.org>
 <4E1DF736.9020908@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E1DF736.9020908@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stratos Psomadakis (psomas@gentoo.org) wrote:
> On 13/07/2011 09:55 μμ, Stratos Psomadakis wrote:
> > On 13/07/2011 05:28 μμ, Marcus Becker wrote:
> >> Hi,
> >>
> >> With the upgrade to 2.6.39.2, I cannot copy more than ~1GB of data
> >> over the network before my input devices lock up.
> >> Example:
> >> use scp on tty1 to copy a folder or file larger than 3GB over my
> >> gigabit network and after ~1min the keyboard stops responding.
> >> use cp on tty1 with an nfs-3 share mounted over the same network and
> >> try to copy the same file, same happens
> >>
> >> I can hit ctrl+c for about 20-30 sec and eventually get an interrupt
> >> that stops the copying, then the input devices slowly gain control
> >> again. If I do the same on X, there is no chance to get in between and
> >> I have to use SysRq to reboot.
> >>
> >> In our bug report at https://bugs.gentoo.org/show_bug.cgi?id=373109
> >> We did a bisect between 2.6.39.1 and 2.6.39.2 and found the following
> >> patch is causing this problem:
> >>
> >> commit 87cc4d1e3e05af38c7c51323a3d86fe2572ab033
> >> Author: Chris Wright <chrisw@sous-sol.org>
> >> Date:   Sat May 28 13:15:04 2011 -0500
> >>
> >>     intel-iommu: Dont cache iova above 32bit
> >>
> >> I will also attach dmesg, current kernel config, and my bisect log (I
> >> put a uname -a into the log after each bisect) plus git bisect log
> >>
> >> Please let me know if you need more information.
> >>
> >> Thanks,
> >>
> >> Marcus
> > CC'ed the people who signed-off the patch.
> >
> Bug #39312 [1] at b.k.o
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=39312

Thanks for the cc, looking into it.  Would be useful to get details of
the boxes that are showing the issue (full dmesg from boot and lspci).
