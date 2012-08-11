Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab2HKLbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 07:31:35 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51539 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754038Ab2HKLbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 07:31:33 -0400
Message-ID: <50264287.9000900@gmail.com>
Date: Sat, 11 Aug 2012 15:31:19 +0400
From: Denis <yefremov.denis@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: balbi@ti.com
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: otg: twl4030-usb: spin_unlock_irq in interrupt handler
References: <1342856418-1451-1-git-send-email-yefremov.denis@gmail.com> <20120809093706.GM12174@arwen.pp.htv.fi>
In-Reply-To: <20120809093706.GM12174@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.08.2012 13:37, Felipe Balbi wrote:
> Hi,
>
> I have pushed a patch which I think solves this issue. Can you test ?
Hi,
my patch is unneeded since this is a threaded interrupt handler. And it 
runs with
interrupt line masked globally on the controller(because of IRQF_ONESHOT).
And I think that "sti" instruction can't reenable this line because it 
is cpu related.
The point was that if "local_irq_enable" is called in primary irq 
handler or in
request_irq handler you reenables (maybe accidentally) interrupts on the 
cpu.
Because after patch https://lkml.org/lkml/2010/3/25/434 these handlers 
runs with
interrupts disabled.
Some time ago our static tool didn't make any difference between 
ordinary and
threaded interrupts handlers. At that time I didn't know it and didn't 
check the
code enough. So it was a false positive.
