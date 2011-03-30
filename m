Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1C3Fhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 01:37:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47856
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045Ab1C3Fhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 01:37:35 -0400
Date: Tue, 29 Mar 2011 22:36:57 -0700 (PDT)
Message-Id: <20110329.223657.70189067.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: jongman.heo@gmail.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: compile error with 2.6.39-rc1 (in arch/x86/kernel/apb_timer.c)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110330022138.GG8529@home.goodmis.org>
References: <loom.20110330T040947-18@post.gmane.org>
	<20110330022138.GG8529@home.goodmis.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 29 Mar 2011 22:21:38 -0400

> On Wed, Mar 30, 2011 at 02:11:57AM +0000, jmheo wrote:
>> 
>> I got following compile error with 2.6.39-rc1.
>> 
>> arch/x86/kernel/apb_timer.c: In function ??apbt_setup_irq??:
>> arch/x86/kernel/apb_timer.c:319:2: error: implicit declaration of function ??
>> __set_irq_handler??
>> make[2]: *** [arch/x86/kernel/apb_timer.o] Error 1
>> make[1]: *** [arch/x86/kernel] Error 2
>> make: *** [arch/x86] Error 2
>> make: *** Waiting for unfinished jobs....
>> 
>> 
>> I have CONFIG_APB_TIMER & CONFIG_SMP in my .config.
> 
> Could you post your full config please.

I hit this as well, even a stock "allmodconfig" build hits this.

A quick "git grep __set_irq_handler" will that that this one reference
apb_timer.c is the only match you'll get.  I don't think you need a
config to see what the problem is here, do you?

