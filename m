Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2BQPlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:41:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49432 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2BQPlq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:41:46 -0500
MIME-Version: 1.0
In-Reply-To: <201201281445.49377.rjw@sisk.pl>
References: <201201281445.49377.rjw@sisk.pl>
Date: Fri, 17 Feb 2012 10:41:44 -0500
Message-ID: <CA+5PVA6m4fM79hFujFXb1-w4UK7ki11yRjrbsFOYi1VeRM4CNw@mail.gmail.com>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system suspend/hibernation
From: Josh Boyer <jwboyer@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 8:45 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Freeze all filesystems during system suspend and (kernel-driven)
> hibernation by calling freeze_supers() for all superblocks and thaw
> them during the subsequent resume with the help of thaw_supers().
>
> This makes filesystems stay in a consistent state in case something
> goes wrong between system suspend (or hibernation) and the subsequent
> resume (e.g. journal replays won't be necessary in those cases).  In
> particular, this should help to solve a long-standing issue that, in
> some cases, during resume from hibernation the boot loader causes the
> journal to be replied for the filesystem containing the kernel image
> and/or initrd causing it to become inconsistent with the information
> stored in the hibernation image.
>
> The user-space-driven hibernation (s2disk) is not covered by this
> change, because the freezing of filesystems prevents s2disk from
> accessing device special files it needs to do its job.
>
> This change is based on earlier work by Nigel Cunningham.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Do you happen to have a version of this patch that has been rebased to the
latest 3.3 git tree?  I looked in the various archives and haven't found one
yet.  I'd like to get this into Fedora rawhide to see if some of the hibernate
issues we've been seeing clear up.

josh
