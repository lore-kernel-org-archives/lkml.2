Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0EOJ5M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 05:57:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56731 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab0EOJ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 05:57:11 -0400
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org,
       Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
From: Andi Kleen <andi@firstfloor.org>
References: <1273887635-27610-1-git-send-email-venki@google.com>
Date: Sat, 15 May 2010 11:57:04 +0200
In-Reply-To: <1273887635-27610-1-git-send-email-venki@google.com> (Venkatesh Pallipadi's message of "Fri\, 14 May 2010 18\:40\:35 -0700")
Message-ID: <87tyq9mqrz.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venkatesh Pallipadi <venki@google.com> writes:

> From: Dan Magenheimer <dan.magenheimer@oracle.com>
>
> Kernel information about calibrated value of tsc_khz and
> tsc_stability (result of tsc warp test) are useful bits of information
> for any app that wants to use TSC directly. Export this read_only
> information in sysfs.

Is this really a good idea?  It will encourage the applications
to use RDTSC directly, but there are all kinds of constraints on
that. Even the kernel has a hard time with them, how likely
is it that applications will get all that right?

It would be better to fix them to use the vsyscalls instead.
Or if they can't use the vsyscalls for some reason today fix them.

This way if anything changes again in TSC the kernel could
shield the applications. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
