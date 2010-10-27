Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab0J0Pka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:40:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:58611 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab0J0Pk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:40:28 -0400
Message-ID: <4CC847D9.3080805@kernel.org>
Date: Wed, 27 Oct 2010 17:40:09 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Brian Gerst <brgerst@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com> <1288158182-1753-1-git-send-email-brgerst@gmail.com> <AANLkTim_3vhuJt2gYQEM5p=wxVU1Jsm6reTgQZsu_o7B@mail.gmail.com> <20101027153053.GA20243@elte.hu> <20101027153331.GA21789@elte.hu>
In-Reply-To: <20101027153331.GA21789@elte.hu>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Oct 2010 15:40:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo, Linus.

On 10/27/2010 05:33 PM, Ingo Molnar wrote:
> Btw., the NUMA stuff never really worked percpu alloc, as per Eric's observation:

Oh, it works in general.  In this case, it's probably because the NUMA
configuration is rather weird in 32bit (but then again NUMA on 32bit
is supposed to be so).  I think it's just 32bit init code setting up
early_cpu_to_node() differently.

>  | Anyway, I just discovered per_cpu data on my machine (NUMA capable) all sit on a 
>  | single node, if 32bit kernel used.
> 
> ... and in practice it's not really relevant on 32-bit anyway. So we can decouple 
> the two issues just fine.

Yeah, the two issues are separate and as I wrote in the other message
the end result is correct (as much as it could be).  I'll try to dig
down what exactly is going on but I don't think there's anything to be
alarmed about.

Thanks.

-- 
tejun
