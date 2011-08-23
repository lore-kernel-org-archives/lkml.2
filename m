Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab1HWTE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:04:56 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:53255
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754873Ab1HWTEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:04:50 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4E53F9CE.1040106@freescale.com>
Date: Tue, 23 Aug 2011 14:04:46 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>
CC: Julia Lawall <julia@diku.dk>, <kernel-janitors@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] arch/powerpc/sysdev/ehv_pic.c: add missing kfree
References: <1312802283-9107-8-git-send-email-julia@diku.dk> <CAOZdJXX_BS7GMtmyqiS91QByhrjANtKpbqrstR8g-L80r_N8qg@mail.gmail.com>
In-Reply-To: <CAOZdJXX_BS7GMtmyqiS91QByhrjANtKpbqrstR8g-L80r_N8qg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben, Kumar, can one of you take a look at my question and help me out?

 wrote:
> On Mon, Aug 8, 2011 at 7:18 AM, Julia Lawall <julia@diku.dk> wrote:
> 
>> diff --git a/arch/powerpc/sysdev/ehv_pic.c b/arch/powerpc/sysdev/ehv_pic.c
>> index af1a5df..b6731e4 100644
>> --- a/arch/powerpc/sysdev/ehv_pic.c
>> +++ b/arch/powerpc/sysdev/ehv_pic.c
>> @@ -280,6 +280,7 @@ void __init ehv_pic_init(void)
>>
>>        if (!ehv_pic->irqhost) {
>>                of_node_put(np);
>> +               kfree(ehv_pic);
>>                return;
>>        }
> 
> Although the fix is correct, I think there is another bug in this
> function.  'np' is not released when the function finishes
> successfully.   I've looked at other functions that use
> irq_alloc_host(), and most of them do the same thing: they don't call
> of_node_put() on the device node pointer.  The only exception I've
> found is mpc5121_ads_cpld_pic_init().
> 
> Ben, Kumar: am I missing something?  irq_alloc_host() calls of_node_get():
> 
> 	host->of_node = of_node_get(of_node);
> 
> so doesn't that mean that the caller of irq_alloc_host() should
> release the device node pointer?
> 


-- 
Timur Tabi
Linux kernel developer at Freescale

