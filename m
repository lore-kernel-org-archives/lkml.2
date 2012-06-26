Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2FZVqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 17:46:08 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:26427
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416Ab2FZVqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 17:46:06 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1202hzz8275bhz2dh2a8h668h839h93fhd25he5bhf0ah)
Message-ID: <4FEA2D93.3030002@freescale.com>
Date: Tue, 26 Jun 2012 16:45:55 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Zhao Chenhui <chenhui.zhao@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com> <AB6D43A9-FC54-40D2-A9B0-8B2E785124F9@kernel.crashing.org>
In-Reply-To: <AB6D43A9-FC54-40D2-A9B0-8B2E785124F9@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 09:03 AM, Kumar Gala wrote:
> 
> On Jun 26, 2012, at 5:25 AM, Zhao Chenhui wrote:
> 
>> Do hardware timebase sync. Firstly, stop all timebases, and transfer
>> the timebase value of the boot core to the other core. Finally,
>> start all timebases.
>>
>> Only apply to dual-core chips, such as MPC8572, P2020, etc.
>>
>> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
>> Signed-off-by: Li Yang <leoli@freescale.com>
>> ---
>> Changes for v6:
>> * added 85xx_TB_SYNC
>> * added isync() after set_tb()
>> * removed extra entries from mpc85xx_smp_guts_ids
> 
> Why only on dual-core chips?  Is this because of something related to
> 2 cores, or related to corenet vs non-corenet SoCs and how turning
> on/off the timebase works in the SOC?

Some parts are due to corenet versus non-corenet, such as the actual
register you write to to disable/enable the timebase.

There's also a two-core assumption in the synchronization code which
I've complained about multiple times -- although on closer inspection it
looks like this is done under cpu_add_remove_lock, and we can assume
that there's only one core at a time in take_timebase(), regardless of
how many cores are in the system.

-Scott

