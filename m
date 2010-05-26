Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab0EZEMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 00:12:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab0EZEMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 00:12:35 -0400
Message-ID: <4BFC9FA5.3040201@redhat.com>
Date: Wed, 26 May 2010 01:12:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: post 2.6.34 bug: new code enabled by default
References: <tkrat.872472794cabd92e@s5r6.in-berlin.de>
In-Reply-To: <tkrat.872472794cabd92e@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> $ make oldconfig
> ...
>   * Multimedia drivers
>   *
>   Compile Remote Controller keymap modules (RC_MAP) [M/n/?] (NEW) n
>   Enable IR raw decoder for the NEC protocol (IR_NEC_DECODER) [M/n/?] (NEW) n
>   Enable IR raw decoder for the RC-5 protocol (IR_RC5_DECODER) [M/n/?] (NEW) n
>   Enable IR raw decoder for the RC6 protocol (IR_RC6_DECODER) [M/n/?] (NEW) n
>   Enable IR raw decoder for the JVC protocol (IR_JVC_DECODER) [M/n/?] (NEW) n
>   Enable IR raw decoder for the Sony protocol (IR_SONY_DECODER) [M/n/?] (NEW) n
> 
> Please leave the default of new options at N.
> 
> (Unless this were a special case of new options that replaced older
> options and need to be migrated to 'on' per default in make oldconfig.
> I think this is not the case here.)

This is the case here. Before the RC subsystem, the decoding for NEC and RC-5
were done inside ir-core (at ir-functions). Also, all the keymap entries (RC_MAP)
were compiled in-kernel.

The intention is to move the RC_MAP keytables to userspace, by default, but there
are still some work to be done at the userspace application before we can do it.

So, without RC_MAP, IR_NEC_DECODER and IR_RC5_DECODER, the input driver will be 
compiled, but the IR support may not actually work, if the board needs IR raw
support.

That's said, the support for RC-6, JVC and Sony protocols (IR_RC6_DECODER, 
IR_JVC_DECODER and IR_SONY_DECODER) are new. Yet, even on this case, it may make
sense to keep the default to Y, or to add a logic to auto-select the IR decoder 
protocols that are needed in order to support the bundled IR found at the compiled
drivers.

-- 

Cheers,
Mauro
