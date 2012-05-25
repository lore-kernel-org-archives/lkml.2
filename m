Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab2EYTIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 15:08:51 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:37557 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab2EYTIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 15:08:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Josh Boyer <jwboyer@gmail.com>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system suspend/hibernation
Date: Fri, 25 May 2012 21:13:50 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <201201281445.49377.rjw@sisk.pl> <201202172159.15396.rjw@sisk.pl> <CA+5PVA50UA1oP1jKgnQjHh8APp=cNWREw3bkfrkV1OW_Tg1g+A@mail.gmail.com>
In-Reply-To: <CA+5PVA50UA1oP1jKgnQjHh8APp=cNWREw3bkfrkV1OW_Tg1g+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205252113.50900.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 25, 2012, Josh Boyer wrote:
> On Fri, Feb 17, 2012 at 3:59 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> commit b94887bbc0621e1e8402e7f0ec4bc3adf46c9a6e
> >> Author: Rafael J. Wysocki <rjw@sisk.pl>
> >> Date:   Fri Feb 17 12:42:08 2012 -0500
> >>
> >>     Freeze all filesystems during system suspend and (kernel-driven)
> >>     hibernation by calling freeze_supers() for all superblocks and thaw
> >>     them during the subsequent resume with the help of thaw_supers().
> >>
> >>     This makes filesystems stay in a consistent state in case something
> >>     goes wrong between system suspend (or hibernation) and the subsequent
> >>     resume (e.g. journal replays won't be necessary in those cases).  In
> >>     particular, this should help to solve a long-standing issue that, in
> >>     some cases, during resume from hibernation the boot loader causes the
> >>     journal to be replied for the filesystem containing the kernel image
> >>     and/or initrd causing it to become inconsistent with the information
> >>     stored in the hibernation image.
> >>
> >>     The user-space-driven hibernation (s2disk) is not covered by this
> >>     change, because the freezing of filesystems prevents s2disk from
> >>     accessing device special files it needs to do its job.
> >>
> >>     This change is based on earlier work by Nigel Cunningham.
> >>
> >>     Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> >>
> >>     Rebased to 3.3-rc3 by Josh Boyer <jwboyer@redhat.com>
> 
> Did this patch ever wind up going anywhere?  Fedora has it sitting in
> our tree with a comment that says "rebase" and I don't see it in the
> linux-next tree at all.
> 
> Did if fall through the cracks or was it NAKed somewhere?

No, it wasn't in principle. There were some comments I haven't addressed yet.

Thanks,
Rafael
