Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1G0MjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 08:39:21 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:55567
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303Ab1G0MjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:39:18 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dK1432N98dKzz1202hzz8275bh8275dhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LOZSGX-02-617-02
X-M-MSG: 
Message-ID: <4E3006DF.6010906@amd.com>
Date: Wed, 27 Jul 2011 08:38:55 -0400
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "ostr@amd64.org" <ostr@amd64.org>, "jvpeetz@web.de" <jvpeetz@web.de>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "tim.bird@am.sony.com" <tim.bird@am.sony.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] [25/98] x86, AMD: Fix APIC timer erratum 400 affecting
 K8 Rev.A-E processors
References: <20110726534.972201586@firstfloor.org> <20110727003517.6946C2403FF@tassilo.jf.intel.com>
In-Reply-To: <20110727003517.6946C2403FF@tassilo.jf.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/11 20:35, Andi Kleen wrote:
> 2.6.35-longterm review patch.  If anyone has any objections, please let me know.
>
> ------------------
> From: Boris Ostrovsky<ostr@amd64.org>
>
> commit e20a2d205c05cef6b5783df339a7d54adeb50962 upstream.
>
> Older AMD K8 processors (Revisions A-E) are affected by erratum
> 400 (APIC timer interrupts don't occur in C states greater than
> C1). This, for example, means that X86_FEATURE_ARAT flag should
> not be set for these parts.
>
> This addresses regression introduced by commit
> b87cf80af3ba4b4c008b4face3c68d604e1715c6 ("x86, AMD: Set ARAT
> feature on AMD processors") where the system may become
> unresponsive until external interrupt (such as keyboard input)
> occurs. This results, for example, in time not being reported
> correctly, lack of progress on the system and other lockups.
>
> Reported-by: Joerg-Volker Peetz<jvpeetz@web.de>
> Tested-by: Joerg-Volker Peetz<jvpeetz@web.de>
> Acked-by: Borislav Petkov<borislav.petkov@amd.com>
> Signed-off-by: Boris Ostrovsky<Boris.Ostrovsky@amd.com>
> Signed-off-by: Andi Kleen<ak@linux.intel.com>
> Link: http://lkml.kernel.org/r/1304113663-6586-1-git-send-email-ostr@amd64.org
> Signed-off-by: Ingo Molnar<mingo@elte.hu>
> Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
>
> ---
>   arch/x86/kernel/cpu/amd.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
> ===================================================================
> --- linux-2.6.35.y.orig/arch/x86/kernel/cpu/amd.c
> +++ linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
> @@ -651,7 +651,7 @@ cpu_dev_register(amd_cpu_dev);
>    */
>
>   const int amd_erratum_400[] =
> -	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
> +	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0x0f, 0x4, 0x2, 0xff, 0xf),
>   			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
>
>
>


Andi, this patch is unnecessary.

It (as well as 328935e6348c6a7cb34798a68c326f4b8372e68a and 
14fb57dccb6e1defe9f89a66f548fcb24c374c1d) is superseded by 
e9cdd343a5e42c43bcda01e609fa23089e026470 upstream


-boris

