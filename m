Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab2F2QCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:02:30 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:26097
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932069Ab2F2QC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:02:29 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zzbb2dI98dI9371I1521I1102I1432Izz1202hzz8275bhz2dh2a8h668h839h93fhd25he5bhf0ah)
Message-ID: <4FEDD07D.3090103@freescale.com>
Date: Fri, 29 Jun 2012 10:57:49 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tabi Timur-B04825 <B04825@freescale.com>
CC: Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com> <CAOZdJXWiGOCtP1iJYR2S48XwR2Wpry8+VswctctdVfY9Z+QTiQ@mail.gmail.com>
In-Reply-To: <CAOZdJXWiGOCtP1iJYR2S48XwR2Wpry8+VswctctdVfY9Z+QTiQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 10:39 AM, Tabi Timur-B04825 wrote:
> On Tue, Jun 26, 2012 at 5:25 AM, Zhao Chenhui
> <chenhui.zhao@freescale.com> wrote:
>> +static void mpc85xx_give_timebase(void)
>> +{
>> +       unsigned long flags;
>> +
>> +       local_irq_save(flags);
>> +
>> +       while (!tb_req)
>> +               barrier();
> 
> I think tb_req and tb_valid need to be 'volatile'.

No, barrier() and mb() take care of that.

>> +static const struct of_device_id mpc85xx_smp_guts_ids[] = {
>> +       { .compatible = "fsl,mpc8572-guts", },
>> +       { .compatible = "fsl,p1020-guts", },
>> +       { .compatible = "fsl,p1021-guts", },
>> +       { .compatible = "fsl,p1022-guts", },
>> +       { .compatible = "fsl,p1023-guts", },
>> +       { .compatible = "fsl,p2020-guts", },
>> +       {},
>> +};
> 
> I wonder if it's possible to dynamically generate the compatible
> string by using the SOC name?

Where are you going to get the SoC name from?

-Scott

