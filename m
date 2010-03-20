Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab0CTBDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 21:03:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111Ab0CTBDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 21:03:50 -0400
Date: Fri, 19 Mar 2010 18:00:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ian Campbell <ian.campbell@citrix.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v4] x86: do not free zero sized per cpu areas
In-Reply-To: <4BA40C83.1030202@kernel.org>
Message-ID: <alpine.LFD.2.00.1003191758460.18017@i5.linux-foundation.org>
References: <4B914A61.20409@kernel.org> <4BA3F82D.5090807@kernel.org> <4BA3F8ED.2090600@zytor.com> <4BA407B8.7070503@kernel.org> <4BA408EE.5000001@zytor.com> <4BA40C83.1030202@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 19 Mar 2010, Yinghai Lu wrote:
> +
> +	if (start > end) {
> +		WARN_ONCE(1,
> +		      "free_early_partial got wrong start/end %#llx/%#llx\n",
> +		      start, end);
> +
> +		return;

This should be written as

	if (WARN_ONCE(start > end, "free_early_partial(%#llx/%#llx)\n", start, end))
		return;

rather than having a separate conditional.

			Linus
