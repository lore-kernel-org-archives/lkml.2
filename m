Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0CSVtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 17:49:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37987 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab0CSVti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 17:49:38 -0400
Message-ID: <4BA3EFAE.9070004@zytor.com>
Date: Fri, 19 Mar 2010 14:42:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: do not free zero sized per cpu areas
References: <4B914A61.20409@kernel.org> <4BA3CF67.9000107@kernel.org>
In-Reply-To: <4BA3CF67.9000107@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 12:24 PM, Yinghai Lu wrote:
> From: Ian Campbell <ian.campbell@citrix.com>
> 
> This avoids an infinite loop in free_early_partial().
> 
> Add a warning to free_early_partial to catch future problems.

Wouldn't it make more sense to simply make free_early_partial() a noop
for the zero range, instead of pushing all those tests into the callers?
 It still might make sense to have a WARN_ONCE() for a *negative* range,
however...

	-hpa
