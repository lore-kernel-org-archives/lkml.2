Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab0GMUiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 16:38:01 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:8077 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab0GMUh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 16:37:57 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 45/50] x86, memblock: Use memblock_debug to control debug message print out
Date: Tue, 13 Jul 2010 14:37:55 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-23-generic; KDE/4.4.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <1279005044-24777-1-git-send-email-yinghai@kernel.org> <1279005044-24777-46-git-send-email-yinghai@kernel.org>
In-Reply-To: <1279005044-24777-46-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007131437.55808.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 13, 2010 01:10:39 am Yinghai Lu wrote:
> -		pr_cont(" ==> [%010llx-%010llx]\n", final_start, final_end - 1);
> +		memblock_dbg(" ==> [%#010llx-%#010llx]\n", final_start, final_end - 1);
>  		reserve_bootmem_generic(final_start, final_end - final_start, BOOTMEM_DEFAULT);
>  	}
>  
> @@ -286,9 +286,11 @@ void __init memblock_x86_reserve_range(u64 start, u64 end, char *name)
>  	if (start == end)
>  		return;
>  
> -	if (WARN_ONCE(start > end, "memblock_x86_reserve_range: wrong range [%#llx, %#llx]\n", start, end))
> +	if (WARN_ONCE(start > end, "memblock_x86_reserve_range: wrong range [%#llx, %#llx)\n", start, end))

Can you print these ranges the same way as the others?  I think
"invalid range" might be closer to what you mean than "wrong range." 

I'm a little dubious about these "(start == end)" and "(start > end)"
checks anyway.  Who are the callers of these functions?  If "start"
and "end" are coming from an external source, e.g., some firmware
interface like an e820 table, the message doesn't give enough of a
clue about where the problem is.

If "start" and "end" are internal things, I'd argue that the checks
are just covering up Linux bugs, and it'd be better to fix those
bugs and remove the checks.

>  		return;
>  
> +	memblock_dbg("    memblock_x86_reserve_range: [%#010llx-%#010llx] %16s\n", start, end - 1, name);
> +
>  	memblock_reserve(start, end - start);
>  }
>  
> @@ -297,9 +299,11 @@ void __init memblock_x86_free_range(u64 start, u64 end)
>  	if (start == end)
>  		return;
>  
> -	if (WARN_ONCE(start > end, "memblock_x86_free_range: wrong range [%#llx, %#llx]\n", start, end))
> +	if (WARN_ONCE(start > end, "memblock_x86_free_range: wrong range [%#llx, %#llx)\n", start, end))
>  		return;

