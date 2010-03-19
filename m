Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab0CSXgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 19:36:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36062 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab0CSXgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 19:36:48 -0400
Message-ID: <4BA408EE.5000001@zytor.com>
Date: Fri, 19 Mar 2010 16:29:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v3] x86: do not free zero sized per cpu areas
References: <4B914A61.20409@kernel.org> <4BA3F82D.5090807@kernel.org> <4BA3F8ED.2090600@zytor.com> <4BA407B8.7070503@kernel.org>
In-Reply-To: <4BA407B8.7070503@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 04:24 PM, Yinghai Lu wrote:
> 
> confused, do you mean like this
> if (start < end), find_overlapped_early will stop the loop.
> 

No.

What I mean is that free_early_partial(), when start == end, is a
legitimate operation that doesn't free anything -- the range is zero
bytes long.  Just return.

When start > end, there is an explicit error we should warn about.

	-hpa
