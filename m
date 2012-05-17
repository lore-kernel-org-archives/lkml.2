Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967596Ab2EQSm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 14:42:56 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:49220
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967533Ab2EQSmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 14:42:54 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839hd25he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4FB546A4.7090502@freescale.com>
Date: Thu, 17 May 2012 13:42:44 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, <linux-kernel@vger.kernel.org>,
        Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: Re: Re: Build regressions/improvements in v3.4-rc7
References: <1337157034-22773-1-git-send-email-geert@linux-m68k.org>  <CAMuHMdUtL4_mv-e-EQAZmNcb9dAT=PXB59i7Vuj2vf8NnaBFzQ@mail.gmail.com> <1337212281.30558.17.camel@pasglop>
In-Reply-To: <1337212281.30558.17.camel@pasglop>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
>   + arch/powerpc/platforms/512x/mpc512x_shared.c: error: 'enum
>> fsl_diu_monitor_port' declared inside parameter list [-Werror]:  =>
>> 70:9, 84:9, 88:36
>>   + arch/powerpc/platforms/512x/mpc512x_shared.c: error: 'return' with
>> a value, in function returning void [-Werror]:  => 189:2
>>   + arch/powerpc/platforms/512x/mpc512x_shared.c: error: function
>> declaration isn't a prototype [-Werror=strict-prototypes]:  => 69:5,
>> 88:6, 83:6, 187:1
>>   + arch/powerpc/platforms/512x/mpc512x_shared.c: error: its scope is
>> only this definition or declaration, which is probably not what you
>> want [-Werror]:  => 70:9

So I think I have a fix for these, but I still would like the actual
.config so that I can be sure.

>>   + drivers/virt/fsl_hypervisor.c: error: 'MSR_GS' undeclared (first
>> use in this function):  => 799:80

I can't reproduce this one.  MSR_GS is defined in reg_booke.h.
fsl_hypervisor.c should not be compiled on a non-booke platform.  I don't
know if the fix is to add this to fsl_hypervisor.c:

	#include <asm/reg_booke.h>

or if I should update the Kconfig:

config FSL_HV_MANAGER
	tristate "Freescale hypervisor management driver"
	depends on FSL_SOC

to

	depends on FSL_BOOKE

or maybe

	depends on FSL_BOOKE && FSL_SOC

-- 
Timur Tabi
Linux kernel developer at Freescale

