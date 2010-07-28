Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab0G1Giz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 02:38:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46172 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab0G1Giw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 02:38:52 -0400
Message-ID: <4C4FD04B.5090503@zytor.com>
Date: Tue, 27 Jul 2010 23:38:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 31/31] memblock: Add memblock_find_in_range()
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org>	 <1279822864-17154-32-git-send-email-yinghai@kernel.org> <1280295415.1970.245.camel@pasglop> <4C4FC95F.6040806@kernel.org>
In-Reply-To: <4C4FC95F.6040806@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 11:08 PM, Yinghai Lu wrote:
> 
> for example: 
> high/low allocation, from first kernel to kexec second kernel, always work fine except system with Qlogic card.
> because Qlogic card is using main RAM as EFT etc for card's FW log trace. second kernel have not idea that those RAM
>  is used by first kernel for that purpose. that the CARD still use that between two kernels.
> second kernel could have crash it try to use those ram.
> 

Uhm, no.  That's a bug in the Qlogic driver not shutting the card down
cleanly.  Hacking around that in memory allocation order is braindamaged
in the extreme.  kexec *cannot* be safe in any way if we don't shut down
pending DMA, and what you describe above is DMA.

> low/high allocation seems to be safe,  second kernel can slip to boot fine.

Low to high is just broken.  Low memory is a special, desirable
resource, and we should minimize the use of it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

