Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762136Ab2CPB36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 21:29:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33324 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297Ab2CPB3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 21:29:55 -0400
Message-ID: <4F62978A.7000009@zytor.com>
Date: Thu, 15 Mar 2012 18:29:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] ntp: Fix integer overflow when setting time
References: <1331829374-31543-2-git-send-email-levinsasha928@gmail.com> <tip-a078c6d0e6288fad6d83fb6d5edd91ddb7b6ab33@git.kernel.org>
In-Reply-To: <tip-a078c6d0e6288fad6d83fb6d5edd91ddb7b6ab33@git.kernel.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 02:53 PM, tip-bot for Sasha Levin wrote:
> Commit-ID:  a078c6d0e6288fad6d83fb6d5edd91ddb7b6ab33
> Gitweb:     http://git.kernel.org/tip/a078c6d0e6288fad6d83fb6d5edd91ddb7b6ab33
> Author:     Sasha Levin <levinsasha928@gmail.com>
> AuthorDate: Thu, 15 Mar 2012 12:36:14 -0400
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Thu, 15 Mar 2012 21:41:34 +0100
> 
> ntp: Fix integer overflow when setting time
> 
> 'long secs' is passed as divisor to div_s64, which accepts a 32bit
> divisor. On 64bit machines that value is trimmed back from 8 bytes
> back to 4, causing a divide by zero when the number is bigger than
> (1 << 32) - 1 and all 32 lower bits are 0.
> 
> Use div64_long() instead.
> 

Perhaps we should use the same kind of multiply-and-shift tricks we're
doing for jiffies conversion?  If nothing else it ought to perform better.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

