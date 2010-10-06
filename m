Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959Ab0JFWM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 18:12:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43702 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536Ab0JFWM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 18:12:57 -0400
Message-ID: <4CACF453.5020205@zytor.com>
Date: Wed, 06 Oct 2010 15:12:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memblock: Fix big size with find_region()
References: <4CA1ABA4.6070803@kernel.org> <20101006140604.982b22d6.akpm@linux-foundation.org>
In-Reply-To: <20101006140604.982b22d6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2010 02:06 PM, Andrew Morton wrote:
> 
> This seems rather odd.  If some caller is passing in size>end then that
> caller is buggy isn't it?  A memory block which ends at 0x1000 and has
> a size of 0x2000 is nonsensical.
> 
> So shouldn't we at leat emit a warning so tht the offending caller can
> be found and fixed?
> 

I don't think this is necessarily a bug in the caller -- it just
indicates that it has a request that is impossible to fulfill -- but
that can happen for a lot of other reasons.

Keep in mind that the range and the size will typically come from
different origins.  As such, it's not clear to me that this is something
that requires printing a specific error message for any more than any
other allocation failure, but perhaps you disagree?

	-hpa


