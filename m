Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665Ab2D0PiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:38:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46326 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760396Ab2D0PiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:38:23 -0400
Message-ID: <4F9ABD67.3060704@lwfinger.net>
Date: Fri, 27 Apr 2012 10:38:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 32-bit ppc kernel
References: <4F973026.3020103@lwfinger.net>  <1335311621.15830.42.camel@pasglop> <4F976352.4060001@lwfinger.net>  <1335327081.21961.28.camel@pasglop> <4F98117C.7080309@lwfinger.net> <1335390257.21961.53.camel@pasglop>
In-Reply-To: <1335390257.21961.53.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 04:44 PM, Benjamin Herrenschmidt wrote:
>
> Do we know what the bad interrupt maps to ? Also what is the value of
> NR_IRQ and do you have SPARSE_IRQ enabled ? Can you try with the latter
> disabled and NR_IRQ set to something large, such as 128 ?
>
> (You may be able to check the interrupt mapping in debugfs)

Sorry, I was unable to find anything in debugfs to help me learn about interrupt 
mapping. The value of CONFIG_NR_IRQS is already 512. I have not tried reducing 
it to 128. The setting for CONFIG_SPARSE_IRQ was on, and changing it to off did 
not make any difference.

I finished the bisection, which led to

commit a79dd5ae5a8f49688d65b89a859f2b98a7ee5538
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Thu Dec 15 11:13:03 2011 +1100

     tty/serial/pmac_zilog: Fix suspend & resume

As this seemed to be an improbable result, I did the full test by checking out 
the previous commit (43ca5d3). That resulted in a "good" result. Then I used 
quilt to add commit a79dd5a as a patch and the fault returned. I then noticed 
that you said in the commit message that "I removed some code for handling 
unexpected interrupt which should never be hit...". It appears that my box does 
indeed hit such an unexpected interrupt.

I could always get rid of the fault by disabling CONFIG_SERIAL_PMACZILOG, but I 
would like to fix the problem if possible.

Thanks,

Larry

