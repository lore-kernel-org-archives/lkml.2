Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab1DMNP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:15:26 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:21962 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1DMNPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:15:24 -0400
Subject: Re: [PATCH] avr32: init cannot ignore signals sent by
 force_sig_info()
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
In-Reply-To: <1301929084-2025-1-git-send-email-matt@console-pimps.org>
References: <1301929084-2025-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Wed, 13 Apr 2011 15:14:48 +0200
Message-ID: <1302700488.10549.2.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Apr 2011 13:14:50.0514 (UTC) FILETIME=[C51A2F20:01CBF9DC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 15:58 +0100, Matt Fleming wrote: 
> From: Matt Fleming <matt.fleming@linux.intel.com>
> 
> We can delete the code that checks to see if we're sending an ignored
> signal to init because force_sig_info() already handles this case.
> force_sig_info() will kill init even if the signal handler is SIG_DFL
> and the scenario described in the comment where init might "generate
> the same exception over and over again" cannot occur (force_sig_info()
> clears SIGNAL_UNKILLABLE to ensure that init will die).
> 
> Also, the use of is_global_init() is not correct in the multhreaded
> case, as Oleg Nesterov explains,
> 
> 	"is_global_init() is not right in theory, /sbin/init can be
> 	multithreaded. And, this doesn't cover the sub-namespace
> 	inits... I'd suggest to check SIGNAL_UNKILLABLE, but looking
> 	closer I think you can simply remove this code."
> 
> It seems this code was copied from arch/powerpc in March 2007 in commit
> 
>   623b0355d5b1 "[AVR32] Clean up exception handling code"
> 
> but the code was deleted from arch/powerpc in November 2009 in commit
> 
>   a0592d42fe3e "powerpc: kill the obsolete code under is_global_init()"
> 
> So catch up with powerpc and delete the bogus code.
> 
> Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>

Thanks for this cleanup, added to the AVR32 tree.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

-- 
Hans-Christian Egtvedt

