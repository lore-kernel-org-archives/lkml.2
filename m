Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030892Ab2CPJsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 05:48:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:44894 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030616Ab2CPJsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 05:48:08 -0400
Date: Fri, 16 Mar 2012 10:48:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: mingo@redhat.com, levinsasha928@gmail.com, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] ntp: Fix integer overflow when setting time
In-Reply-To: <4F62978A.7000009@zytor.com>
Message-ID: <alpine.LFD.2.02.1203161047220.2466@ionos>
References: <1331829374-31543-2-git-send-email-levinsasha928@gmail.com> <tip-a078c6d0e6288fad6d83fb6d5edd91ddb7b6ab33@git.kernel.org> <4F62978A.7000009@zytor.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012, H. Peter Anvin wrote:

> On 03/15/2012 02:53 PM, tip-bot for Sasha Levin wrote:
> > Commit-ID:  a078c6d0e6288fad6d83fb6d5edd91ddb7b6ab33
> > Gitweb:     http://git.kernel.org/tip/a078c6d0e6288fad6d83fb6d5edd91ddb7b6ab33
> > Author:     Sasha Levin <levinsasha928@gmail.com>
> > AuthorDate: Thu, 15 Mar 2012 12:36:14 -0400
> > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > CommitDate: Thu, 15 Mar 2012 21:41:34 +0100
> > 
> > ntp: Fix integer overflow when setting time
> > 
> > 'long secs' is passed as divisor to div_s64, which accepts a 32bit
> > divisor. On 64bit machines that value is trimmed back from 8 bytes
> > back to 4, causing a divide by zero when the number is bigger than
> > (1 << 32) - 1 and all 32 lower bits are 0.
> > 
> > Use div64_long() instead.
> > 
> 
> Perhaps we should use the same kind of multiply-and-shift tricks we're
> doing for jiffies conversion?  If nothing else it ought to perform better.

It's not a hotpath where performance matters, but divide by zero does :)
