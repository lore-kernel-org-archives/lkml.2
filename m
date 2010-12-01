Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0LAROu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:14:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36143 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab0LAROs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:14:48 -0500
Date: Wed, 1 Dec 2010 17:14:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Caudle <scaudle@codeaurora.org>
Cc: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        adharmap@codeaurora.org, linux-kernel@vger.kernel.org, miltonm@bga.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] [ARM] gic: Unmask private interrupts on all cores
	during IRQ enable
Message-ID: <20101201171425.GA29347@n2100.arm.linux.org.uk>
References: <1288820762-16077-1-git-send-email-scaudle@codeaurora.org> <20101130180718.GB8521@n2100.arm.linux.org.uk> <4CF6797A.2010807@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF6797A.2010807@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 11:36:10AM -0500, Stephen Caudle wrote:
> On 11/30/2010 01:07 PM, Russell King - ARM Linux wrote:
>> Sorry, missed this.
>>
>> If it's a private peripheral, it can only be accessed from its associated
>> CPU.  What that means is you don't want to enable the interrupt on other
>> CPUs as the peripheral may not be present or initialized on that CPU.
>
> Understood.  But the alternative is to require all code that requests a  
> PPI to have to enable the IRQ on the other cores.  This seems  
> unreasonable to me.

It is also unreasonable to have one core enabling the PPI on other
cores where the hardware behind the interrupt may not have been
initialized yet.  If it is a private interrupt for a private peripheral,
then only the associated CPU should be enabling that interrupt.

I guess this is something which genirq can't cope with, in which case
either genirq needs to be modified to cope with private CPU interrupts,
which are controlled individually by their associated CPU, or we need a
private interface to support this.
