Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313Ab0JRUsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:48:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40754 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335Ab0JRUsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:48:31 -0400
Message-ID: <4CBCB28A.9010602@zytor.com>
Date: Mon, 18 Oct 2010 13:48:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] x86: Cleanup TIF value gaps in shift range
References: <1287434158-24362-1-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1287434158-24362-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2010 01:35 PM, Frederic Weisbecker wrote:
> 9, 19 and 26 values are missing from the TIF shift range, probably
> due to flags that were removed by the past. Now repack the range
> so that we can quickly retrieve the remaining free shift slots.
> 
> But take care of keeping the seperation between high and low bits
> as some masks are created on top of this boundary.
> 

What is the point of this?  All it seems is that it would make stupid
debugging mistakes possible because someone looks at the values from the
wrong kernel.

Feel free to put comments in:

/* 9 - unused - was TIF_xxx */

... but I think gratuitous compaction is a really bad idea.

Nacked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa

