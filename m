Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab0HRIKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:10:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44927 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab0HRIKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:10:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C6B9547.8060509@s5r6.in-berlin.de>
Date: Wed, 18 Aug 2010 10:09:43 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: Yong Zhang <yong.zhang0@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: lockdep false positive? -- firewire-core transaction timer vs.
 scsi-core host lock
References: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de>	<20100817143509.GC2838@zhy> <4C6AB76C.9060809@s5r6.in-berlin.de> <4C6B8562.1070902@ladisch.de>
In-Reply-To: <4C6B8562.1070902@ladisch.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Ladisch wrote:
> firewire: core: do not use del_timer_sync() in interrupt context
> 
> Because we might be in interrupt context, replace del_timer_sync() with
> del_timer().

Again, is the term "interrupt contexts" meant to include softIRQ contexts?

(Nothing in firewire-core/-sbp2/-net etc. is called in hardware
interrupts.  BTW, we actually could and maybe should change all the
spinlocks in them from spin_lock_irq to spin_lock_bh.  Only
firewire-ohci's local ohci->lock needs to be IRQ safe.  OTOH this could
change if somebody comes up with a migration of the stack to threaded
IRQ handling.)
-- 
Stefan Richter
-=====-==-=- =--- =--=-
http://arcgraph.de/sr/
