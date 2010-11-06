Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab0KFDgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 23:36:06 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28056 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab0KFDgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 23:36:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6158"; a="60789634"
Message-ID: <4CD4CD21.8080801@codeaurora.org>
Date: Fri, 05 Nov 2010 20:36:01 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@fluxnic.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 2/3] ARM: Allow machines to override __delay()
References: <1288300770-18350-1-git-send-email-sboyd@codeaurora.org>	<1288300770-18350-3-git-send-email-sboyd@codeaurora.org>	<1288899002.21823.3.camel@c-dwalke-linux.qualcomm.com>	<4CD31E67.60107@codeaurora.org>	<1288905414.21823.12.camel@c-dwalke-linux.qualcomm.com>	<4CD47C6E.3050702@codeaurora.org> <1289000592.15381.23.camel@m0nster>
In-Reply-To: <1289000592.15381.23.camel@m0nster>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2010 04:43 PM, Daniel Walker wrote:
> On Fri, 2010-11-05 at 14:51 -0700, Stephen Boyd wrote:
>> Ok. Doing that increases the size of my vmlinux.
>>
>> $ size vmlinux.orig vmlinux.new
>>    text    data     bss     dec     hex filename
>> 7091426  594512 1244648 8930586  88451a vmlinux.orig
>> 7091514  594512 1244648 8930674  884572 vmlinux.new
>
> This is what I get,
>
>    text    data     bss     dec     hex filename
> 2168427  104288  186176 2458891  25850b ../build-test/vmlinux.orig
> 2168379  104288  186176 2458843  2584db ../build-test/vmlinux.new
>
> Your patch has something wrong with it, which I fixed. Details below,
>
[snip]
>> - */
>> -void __delay(unsigned long loops)
>> -{
>> -	delay_fn(loops);
>> -}
>>  EXPORT_SYMBOL(__delay);
>
> You need to modify this EXPORT_SYMBOL to delay_fn since __delay doesn't
> exist anymore.

Wait. Doesn't this mean we're exporting delay_fn instead of __delay now?
i.e. the symbol name has changed and modules can no longer call __delay?
That sounds bad.

If I make that change, my kernel size is exactly the same before and
after. It may sound like a win since you got a decrease and I got a net
zero, but I'm not sure since the symbol has changed. I could make
__delay a function pointer and assign it directly but I'm not very
interested to expose a function pointer to modules allowing them to
modify it at any time (easily). Actually, I should probably mark
set_delay_fn __init so it gets thrown away after init when its far too
late to switch the delay function anyway. That would give you the space
savings you want and allow me to keep the delay_fn static to delay.c

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

