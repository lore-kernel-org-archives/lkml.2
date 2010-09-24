Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0IXAXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 20:23:09 -0400
Received: from claw.goop.org ([74.207.240.146]:44504 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab0IXAXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 20:23:07 -0400
Message-ID: <4C9BEF6A.9040107@goop.org>
Date: Thu, 23 Sep 2010 17:23:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Potential race in irq_chip_set_defaults()?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 irq_chip_set_defaults() modifies the irq_chip structure in-place when
setting up an irq.  If that happens on multiple CPUs at once then it
could leave the irq_chip structure in an inconsistent state.

Is there anything preventing that case from happening?  There's no
locking, and as far as I know there's no rule forbidding concurrent
calls to set_irq_chip()/irq_chip_set_defaults().

Thanks,
    J
