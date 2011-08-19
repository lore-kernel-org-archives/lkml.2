Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab1HSTB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:01:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50578 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab1HSTBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:01:52 -0400
Message-ID: <4E4EB31B.70709@suse.cz>
Date: Fri, 19 Aug 2011 21:01:47 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: mikeci@acm.org
CC: linux-kernel@vger.kernel.org
Subject: Re: Possible bug in 8250.c
References: <26505.1313775887@sonic.net>
In-Reply-To: <26505.1313775887@sonic.net>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2011 07:44 PM, Ivica Mikec wrote:
> 
>  Hi!
> 
> 
> I noticed a problem in 8250.c. 
> 
> My board has only one UART port, and is 16550 compatible, so in function serial8250_interrupt I see that serial_in function is called twice. Second time, code "else if (end == NULL)" is executed and function return IRQ_NONE. This causes an entry in /proc/irq/spurious:
> 
> count 239
> unhandled 1
> last_unhandled 4294700846 ms
> 
> But this is not a spurious interrupt.

How did you find out? Have you checked that the port signals that it
raised an interrupt? I.e. does it go through the 'if (!(iir &
UART_IIR_NO_INT))' branch?

What other devices are bound to the same interrupt? Attach /proc/interrupts.

regards,
-- 
js
suse labs
