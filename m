Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab1A0Ruq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 12:50:46 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:18833 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab1A0Rup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 12:50:45 -0500
Message-ID: <4D41B06F.8070804@caviumnetworks.com>
Date: Thu, 27 Jan 2011 09:50:39 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Coly Li <bosong.ly@taobao.com>
CC: linux-kernel@vger.kernel.org, Wang Cong <xiyou.wangcong@gmail.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-mips <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 1/7] MIPS: add unlikely() to BUG_ON()
References: <1296130356-29896-1-git-send-email-bosong.ly@taobao.com> <1296130356-29896-2-git-send-email-bosong.ly@taobao.com>
In-Reply-To: <1296130356-29896-2-git-send-email-bosong.ly@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jan 2011 17:50:45.0114 (UTC) FILETIME=[B904ADA0:01CBBE4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please Cc: linux-mips@linux-mips.org for MIPS patches.

On 01/27/2011 04:12 AM, Coly Li wrote:
> Current BUG_ON() in arch/mips/include/asm/bug.h does not use unlikely(),
> in order to get better branch predict result, source code should call
> BUG_ON() with unlikely() explicitly. This is not a suggested method to
> use BUG_ON().
>
> This patch adds unlikely() inside BUG_ON implementation on MIPS code,
> callers can use BUG_ON without explicit unlikely() now.
>
> I have no usable MIPS hardware to build and test the fix, any test result
> of this patch is welcome.
>
> Signed-off-by: Coly Li<bosong.ly@taobao.com>
> Cc: David Daney<ddaney@caviumnetworks.com>
> Cc: Wang Cong<xiyou.wangcong@gmail.com>
> Cc: Yong Zhang<yong.zhang0@gmail.com>
> ---
>   arch/mips/include/asm/bug.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/mips/include/asm/bug.h b/arch/mips/include/asm/bug.h
> index 540c98a..6771c07 100644
> --- a/arch/mips/include/asm/bug.h
> +++ b/arch/mips/include/asm/bug.h
> @@ -30,7 +30,7 @@ static inline void  __BUG_ON(unsigned long condition)
>   			     : : "r" (condition), "i" (BRK_BUG));
>   }
>
> -#define BUG_ON(C) __BUG_ON((unsigned long)(C))
> +#define BUG_ON(C) __BUG_ON((unsigned long)unlikely(C))
>

NAK.

__BUG_ON() expands to a single instruction.  Frobbing about with 
unlikely() will have no effect on the generated code and is thus 
gratuitous code churn.

David Daney
