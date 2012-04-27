Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab2D0W0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:26:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:45506 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab2D0W0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:26:30 -0400
Message-ID: <1335565573.20866.7.camel@pasglop>
Subject: Re: Regression in 32-bit ppc kernel
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 28 Apr 2012 08:26:13 +1000
In-Reply-To: <4F9ABD67.3060704@lwfinger.net>
References: <4F973026.3020103@lwfinger.net>
	 <1335311621.15830.42.camel@pasglop> <4F976352.4060001@lwfinger.net>
	 <1335327081.21961.28.camel@pasglop> <4F98117C.7080309@lwfinger.net>
	 <1335390257.21961.53.camel@pasglop> <4F9ABD67.3060704@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 10:38 -0500, Larry Finger wrote:

> Sorry, I was unable to find anything in debugfs to help me learn about interrupt 
> mapping. The value of CONFIG_NR_IRQS is already 512. I have not tried reducing 
> it to 128. The setting for CONFIG_SPARSE_IRQ was on, and changing it to off did 
> not make any difference.
> 
> I finished the bisection, which led to
> 
> commit a79dd5ae5a8f49688d65b89a859f2b98a7ee5538
> Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date:   Thu Dec 15 11:13:03 2011 +1100
> 
>      tty/serial/pmac_zilog: Fix suspend & resume
> 
> As this seemed to be an improbable result, I did the full test by checking out 
> the previous commit (43ca5d3). That resulted in a "good" result. Then I used 
> quilt to add commit a79dd5a as a patch and the fault returned. I then noticed 
> that you said in the commit message that "I removed some code for handling 
> unexpected interrupt which should never be hit...". It appears that my box does 
> indeed hit such an unexpected interrupt.
> 
> I could always get rid of the fault by disabling CONFIG_SERIAL_PMACZILOG, but I 
> would like to fix the problem if possible.

Right, it should be fixed. I need to understand where the unexpected
interrupt comes from. Can you tell me (or remind me) what specific
machine model you are using ? Are you putting the console on the serial
port ?

Cheers,
Ben.


