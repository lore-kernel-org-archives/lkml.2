Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab0CZU56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 16:57:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43328 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab0CZU54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 16:57:56 -0400
Date: Fri, 26 Mar 2010 18:18:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
       linux-arm-kernel@lists.infradead.org, linux-pcmcia@lists.infradead.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: pcmcia: fix checkpatch.pl issues in
	soc_common.c
Message-ID: <20100326181800.GB21682@n2100.arm.linux.org.uk>
References: <1269471898-26301-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br> <1269471898-26301-2-git-send-email-mroberto@cpti.cetuc.puc-rio.br> <20100324230729.GA21359@n2100.arm.linux.org.uk> <4BAB38B1.8080404@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAB38B1.8080404@ru.mvista.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 01:19:29PM +0300, Sergei Shtylyov wrote:
> Hello.
>
> Russell King - ARM Linux wrote:
>
>>> -	debug(skt, 2, "mask: %s%s%s%s%s%sflags: %s%s%s%s%s%sVcc %d Vpp %d irq %d\n",
>>> -			(state->csc_mask==0)?"<NONE> ":"",
>>> -			(state->csc_mask&SS_DETECT)?"DETECT ":"",
>>> -			(state->csc_mask&SS_READY)?"READY ":"",
>>> -			(state->csc_mask&SS_BATDEAD)?"BATDEAD ":"",
>>> -			(state->csc_mask&SS_BATWARN)?"BATWARN ":"",
>>> -			(state->csc_mask&SS_STSCHG)?"STSCHG ":"",
>>> -			(state->flags==0)?"<NONE> ":"",
>>> -			(state->flags&SS_PWR_AUTO)?"PWR_AUTO ":"",
>>> -			(state->flags&SS_IOCARD)?"IOCARD ":"",
>>> -			(state->flags&SS_RESET)?"RESET ":"",
>>> -			(state->flags&SS_SPKR_ENA)?"SPKR_ENA ":"",
>>> -			(state->flags&SS_OUTPUT_ENA)?"OUTPUT_ENA ":"",
>>> +	debug(skt, 2,	"mask: %s%s%s%s%s%s "
>>> +			"flags: %s%s%s%s%s%s Vcc %d Vpp %d irq %d\n",
>>>     
>>
>> NAK.  Breaking kernel messages across multiple lines makes them impossible
>> to grep for.  checkpatch.pl is wrong on this one.
>>   
>
>   I'd disagree in this case. Anybody will hardly grep for "mask:  
> %s%s%s%s%s%sflags: %s%s%s%s%s%s".

Well, I disagree on a matter of principle with you.  If you want to avoid
the line going over 80 columns, move the entire string onto the next line.
Then we can have the entire string intact _and_ we can have it fitting
within 80 columns.
