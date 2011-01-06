Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1AFRgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:36:37 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:18805 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab1AFRgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 12:36:36 -0500
Message-ID: <4D25FDA3.5000807@caviumnetworks.com>
Date: Thu, 06 Jan 2011 09:36:35 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/6] MIPS: pfn_valid() is broken on low memory
 HIGHMEM systems
References: <8eec0c63f92528c501c0e6a0c8396359@localhost> <b2191149ada0fd929b3818c51298ae8d@localhost>
In-Reply-To: <b2191149ada0fd929b3818c51298ae8d@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jan 2011 17:36:36.0098 (UTC) FILETIME=[444A5E20:01CBADC8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 11:31 PM, Kevin Cernekee wrote:
[...]
> diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
> index 2efcbd2..18183a4 100644
> --- a/arch/mips/mm/init.c
> +++ b/arch/mips/mm/init.c
> @@ -370,7 +370,7 @@ void __init mem_init(void)
>   #ifdef CONFIG_DISCONTIGMEM
>   #error "CONFIG_HIGHMEM and CONFIG_DISCONTIGMEM dont work together yet"
>   #endif
> -	max_mapnr = highend_pfn;
> +	max_mapnr = highend_pfn ? : max_low_pfn;

That is not standard C.

How about: max_mapnr = highend_pfn ? highend_pfn : max_low_pfn;

David Daney
