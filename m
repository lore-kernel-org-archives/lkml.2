Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab2A2Tus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 14:50:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55136 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab2A2TuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 14:50:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system suspend/hibernation
Date: Sun, 29 Jan 2012 20:53:52 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <201201281445.49377.rjw@sisk.pl> <201201291655.17056.Martin@lichtvoll.de>
In-Reply-To: <201201291655.17056.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201292053.53085.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 29, 2012, Martin Steigerwald wrote:
> Am Samstag, 28. Januar 2012 schrieb Rafael J. Wysocki:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Freeze all filesystems during system suspend and (kernel-driven)
> > hibernation by calling freeze_supers() for all superblocks and thaw
> > them during the subsequent resume with the help of thaw_supers().
> > 
> > This makes filesystems stay in a consistent state in case something
> > goes wrong between system suspend (or hibernation) and the subsequent
> > resume (e.g. journal replays won't be necessary in those cases).  In
> > particular, this should help to solve a long-standing issue that, in
> > some cases, during resume from hibernation the boot loader causes the
> > journal to be replied for the filesystem containing the kernel image
> 
> replied => replayed

Right, thanks!

Rafael
