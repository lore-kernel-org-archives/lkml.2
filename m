Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1DUOHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:07:39 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:38126 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751850Ab1DUOHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:07:38 -0400
Message-ID: <4DB03A4B.9040807@metafoo.de>
Date: Thu, 21 Apr 2011 16:08:11 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        linux-kernel@vger.kernel.org, toshiharu-linux@dsn.okisemi.com
Subject: Re: Question: GPIO driver how to get irq_base
References: <F9B588C24C5F470494D57D4EFFB14C6B@hacdom.okisemi.com> <4DAFE62A.105@metafoo.de> <20110421134524.GA32725@ponder.secretlab.ca>
In-Reply-To: <20110421134524.GA32725@ponder.secretlab.ca>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2011 03:45 PM, Grant Likely wrote:
> On Thu, Apr 21, 2011 at 10:09:14AM +0200, Lars-Peter Clausen wrote:
>> [...]
>>
>> In my opinion the best option for expander chips is to allocate a new irq_desc
>> range by calling irq_alloc_descs. It will return the first irq number in the
>> newly allocated range, which will be your irq_base.
> 
> Yes, irq_alloc_descs() will give you a range of irqs that the gpio
> expander can use.  In many drivers, the irq_base is hard coded in the
> board file and passed in via pdata, but as much as possible I
> recommend avoiding that and letting Linux dynamically allocate the
> irq_base for you.  Setting gpio_base to -1 will do this.
> 
> The ->to_irq() hook in your driver can translate
> from a gpio number to an irq number for a specific gpio.
> 
>> But be aware that this will require SPARSE_IRQ to work.
> 
> Why?
> 

Because in a non-SPARSE_IRQ setup all irq_descs will be allocated by default.
See early_irq_init for the non-SPARSE_IRQ case in kernel/irq/irq_desc.c.

Though platform code could make irq_descs explicitly available byfirst setting
NR_IRQS to a larger number then it actually requires and then call
irq_free_descs for those irqs which are not used by platform code, but using
SPARSE_IRQ is in my opinion the better alternative in this case.

- Lars

