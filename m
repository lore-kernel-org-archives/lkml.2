Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab1CYRbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:31:42 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:50307 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1CYRbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:31:41 -0400
Message-ID: <4D8CD17C.9040104@tilera.com>
Date: Fri, 25 Mar 2011 13:31:40 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/2] tile: Final irq bits for .39
References: <20110325141938.846639464@linutronix.de>
In-Reply-To: <20110325141938.846639464@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/2011 10:21 AM, Thomas Gleixner wrote:
> Chris,
>
> the series converts the irq functions to the new function names and
> makes use of the generic show_interrupts() implementation.
>
> Can you please ack or send it to Linus yourself ?

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

I'd probably prefer you send it, but if you'd like me to, let me know.  I
confirmed that I can build and boot with your change, and that
/proc/interrupts produces something reasonable.

Well, no less reasonable than usual for our chip, anyway; this is for a
chip on a PCIe board, so no PCI or other interrupt sources plugged in:

# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       CPU6       CPU7       CPU8       CPU9       CPU10      CPU11      CPU12      CPU13      CPU14      CPU15      CPU16      CPU17      CPU18      CPU19      CPU20      CPU21      CPU22      CPU23      CPU24      CPU25      CPU26      CPU27      CPU28      CPU29      CPU30      CPU31      CPU32      CPU33      CPU34      CPU35      CPU36      CPU37      CPU38      CPU39      CPU40      CPU41      CPU42      CPU43      CPU44      CPU45      CPU46      CPU47      CPU48      CPU49      CPU50      CPU51      CPU52      CPU53      CPU54      CPU55      CPU58
  1:        479        313          8          3          3          3          3          3          3          3          4          4          4          4          4          4         10          4          4          4          4          4          4          4          4          4          3         39         84         35          9          5          5          3          3          3          3          3          3          3          3          9          3          4          4          4          4         10          4          4        109          4          4          4          4          4        134  tile_irq_chip  resched


-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

