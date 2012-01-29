Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab2A2PzU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 10:55:20 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36860 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab2A2PzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 10:55:18 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system suspend/hibernation
Date: Sun, 29 Jan 2012 16:55:16 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <201201281445.49377.rjw@sisk.pl> (sfid-20120128_144852_208795_82DBB4A2)
In-Reply-To: <201201281445.49377.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201291655.17056.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 28. Januar 2012 schrieb Rafael J. Wysocki:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Freeze all filesystems during system suspend and (kernel-driven)
> hibernation by calling freeze_supers() for all superblocks and thaw
> them during the subsequent resume with the help of thaw_supers().
> 
> This makes filesystems stay in a consistent state in case something
> goes wrong between system suspend (or hibernation) and the subsequent
> resume (e.g. journal replays won't be necessary in those cases).  In
> particular, this should help to solve a long-standing issue that, in
> some cases, during resume from hibernation the boot loader causes the
> journal to be replied for the filesystem containing the kernel image

replied => replayed

> and/or initrd causing it to become inconsistent with the information
> stored in the hibernation image.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
