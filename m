Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab2HFQPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:15:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:46064 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2HFQPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:15:08 -0400
Message-ID: <501FED75.5060206@linutronix.de>
Date: Mon, 06 Aug 2012 18:14:45 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ptrace: DEBUGCTLMSR_BTF fixes
References: <20120803162912.GA19767@redhat.com>
In-Reply-To: <20120803162912.GA19767@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 06:29 PM, Oleg Nesterov wrote:

> Assuming this series passes the review of course. And it would
> be really nice if someone reviews 2/2, I am not confident that
> I fully understand this DEBUGCTLMSR_BTF magic.

Here is how the processor disables the BTF:

| The processor clears the BTF flag when it generates a debug
| exception. The debugger must set the BTF flag before resuming program
| execution to continue single-stepping on branches.

This was a quote from "253668-039US, May 2011" page 16-17.

So I think __switch_to_extra() should set the bit before putting the
task on the CPU. If this bit is enabled on the wrong CPU then in will
remain set forever if single steeping has not been / will not be
enabled.

> Oleg.
>

Sebastian
