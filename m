Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab0KHQNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:13:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35684 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab0KHQNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:13:37 -0500
Message-ID: <4CD82195.6080905@zytor.com>
Date: Mon, 08 Nov 2010 08:13:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: more fixes and cleanup to AMD Fam10 MMCONF	 enabling
References: <4CD3F18E0200007800020B6D@vpn.id2.novell.com>
In-Reply-To: <4CD3F18E0200007800020B6D@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2010 03:59 AM, Jan Beulich wrote:
>  
> --- 2.6.37-rc1-x86_64-mmconf-fam10h.orig/arch/x86/kernel/mmconf-fam10h_64.c
> +++ 2.6.37-rc1-x86_64-mmconf-fam10h/arch/x86/kernel/mmconf-fam10h_64.c
> @@ -43,7 +43,7 @@ static int __cpuinit cmp_range(const voi
>  	return start1 - start2;
>  }
>  
> -#define UNIT (1ULL << (5 + 3 + 12))
> +#define UNIT (1ULL << FAM10H_MMIO_CONF_BASE_SHIFT)
>  #define MASK (~(UNIT - 1))
>  #define SIZE (UNIT << 8)

Could we avoid macros named UNIT, MASK, and SIZE at all?  I realize
they're already in the code, but still...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

