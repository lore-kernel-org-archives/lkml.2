Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab2BBDRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 22:17:46 -0500
Received: from tuxonice.net ([96.126.116.212]:45603 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914Ab2BBDRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 22:17:45 -0500
X-Bogosity: Unsure, spamicity=0.520000
Message-ID: <4F2A0055.1060306@tuxonice.net>
Date: Thu, 02 Feb 2012 14:17:41 +1100
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Pavel Machek <pavel@ucw.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system suspend/hibernation
References: <201201281445.49377.rjw@sisk.pl>
In-Reply-To: <201201281445.49377.rjw@sisk.pl>
X-TagToolbar-Keys: D20120202141741415
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 29/01/12 00:45, Rafael J. Wysocki wrote:
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

Acked-by: Nigel Cunningham <nigel@tuxonice.net>


(Or reviewed by or whatever :> I'm out of the loop too much, and don't
remember what the right one is!)

-- 
Evolution (n): A hypothetical process whereby improbable
events occur with alarming frequency, order arises from chaos, and
no one is given credit.
