Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0LPJz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 04:55:28 -0500
Received: from www.tglx.de ([62.245.132.106]:33471 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab0LPJz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 04:55:26 -0500
Message-ID: <4D09E207.8080001@linutronix.de>
Date: Thu, 16 Dec 2010 10:55:19 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [PATCH 01/11] x86/kernel: remove conditional early remap in parse_e820_ext
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de> <1290706801-7323-2-git-send-email-bigeasy@linutronix.de> <4D094F1A.3020906@zytor.com>
In-Reply-To: <4D094F1A.3020906@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> I like the fact that this puts all the mapping in the same layer, but I
> also think it's unfortunate to discard the optimization of always
> mapping the minimum of <header length, rest of page>; your code will
> *always* map-unmap-map the code, even in the (presumably very common)
> case of the data fitting on a single page.

Okay, I will take this into account.

> Furthermore, your code retains a minor bug from the original code, which
> is that if the header is not page-aligned, it may be needlessly map more
> than one page with unknown content.

I just checked that early_memremap() maps the memory if it is not on a
page boundary. I take care of this.

> I also found your patch description to be needlessly hard to follow.
> The key point is that it puts all the map manipulation into
> parse_setup_data() where it belongs.  Since you're changing an
> interface, however, also do note that you have checked that there are no
> other callers to parse_e820_ext().

okay.

> 	-hpa


Sebastian
