Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab1E0UJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:09:25 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:32959 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab1E0UJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:09:24 -0400
Message-ID: <4DE004EF.10507@landley.net>
Date: Fri, 27 May 2011 15:09:19 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: MIPS panic in 2.6.39 (bisected to 7eaceaccab5f)
References: <4DDB5673.5060206@landley.net> <20110524143937.GB30117@linux-mips.org> <4DDCB1EB.4020707@landley.net> <20110527075512.GE30117@linux-mips.org> <20110527140011.GF30117@linux-mips.org>
In-Reply-To: <20110527140011.GF30117@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2011 09:00 AM, Ralf Baechle wrote:
> On Fri, May 27, 2011 at 08:55:13AM +0100, Ralf Baechle wrote:
> 
>>> Have you guys been able to reproduce the problem?
>>
>> Staring at the disassembly was good enough, I think.  The commit you
>> bisected is restructuring some of the hardware probing code for Malta and
>> seems to result in gcmp_present being set without _gcmp_base having been
>> assigned, thus the null pointer dereference.
> 
> Can you test below patch?  Thanks,

arch/mips/mti-malta/malta-init.c: In function 'prom_init':
arch/mips/mti-malta/malta-init.c:363: error: implicit declaration of
function 'register_cmp_smp_ops'
arch/mips/mti-malta/malta-init.c:366: error: implicit declaration of
function 'register_vsmp_smp_ops'
make[2]: *** [arch/mips/mti-malta/malta-init.o] Error 1

Rob
