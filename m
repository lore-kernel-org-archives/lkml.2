Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422796Ab2CPOnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:43:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38327 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422778Ab2CPOnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:43:08 -0400
Message-ID: <4F63516E.90602@zytor.com>
Date: Fri, 16 Mar 2012 07:42:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mingo@redhat.com, levinsasha928@gmail.com, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] ntp: Fix integer overflow when setting time
References: <1331829374-31543-2-git-send-email-levinsasha928@gmail.com> <tip-a078c6d0e6288fad6d83fb6d5edd91ddb7b6ab33@git.kernel.org> <4F62978A.7000009@zytor.com> <alpine.LFD.2.02.1203161047220.2466@ionos>
In-Reply-To: <alpine.LFD.2.02.1203161047220.2466@ionos>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 02:48 AM, Thomas Gleixner wrote:
>>
>> Perhaps we should use the same kind of multiply-and-shift tricks we're
>> doing for jiffies conversion?  If nothing else it ought to perform better.
> 
> It's not a hotpath where performance matters, but divide by zero does :)

Doing the inverse multiply wouldn't have a divide by zero problem.  What
perhaps is more important (and the reason we went to shift-multiply) is
that in addition to being faster, it also avoids unnnecessary overflows.
 I would really like to figure out how to do proper shift-multiply for
the 64-bit jiffy conversions too.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

