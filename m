Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab2HHJfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:35:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:57275 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab2HHJfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:35:36 -0400
Message-ID: <502232DE.30702@linutronix.de>
Date: Wed, 08 Aug 2012 11:35:26 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com
Subject: Re: [PATCH 3/5] uprobes: remove check for uprobe variable in handle_swbp()
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-4-git-send-email-bigeasy@linutronix.de> <50222D11.4010005@in.ibm.com>
In-Reply-To: <50222D11.4010005@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 11:10 AM, Suzuki K. Poulose wrote:
>> --- a/kernel/events/uprobes.c
>> +++ b/kernel/events/uprobes.c
>> @@ -1528,17 +1528,15 @@ cleanup_ret:
>> utask->active_uprobe = NULL;
>> utask->state = UTASK_RUNNING;
>> }
>> - if (uprobe) {
>> - if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
>> + if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
>>
> Shouldn't we check uprobe != NULL before we check the uprobe->flags ?
> i.e, shouldn't the above line be :
>
> if (uprobe && ! (uprobe->flags & UPROBE_SKIP_SSTEP)) ?

The function starts like this:

          if (!uprobe) {
                  if (is_swbp > 0) {
                          send_sig(SIGTRAP, current, 0);
                  } else {
                          instruction_pointer_set(regs, bp_vaddr);
                  }
                  return;
          }

Which makes uprobe != NULL by the time we get there, no?

Sebastian
