Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab1IWUQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:16:08 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:11235
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784Ab1IWUQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:16:06 -0400
X-SpamScore: -10
X-BigFish: VPS-10(z5c5ozbb2dK148cM1432N98dKzz1202hzzz2fh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 0,
Message-ID: <4E7CE8E0.5070604@am.sony.com>
Date: Fri, 23 Sep 2011 13:15:28 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] preempt-rt: allow immediate Magic SysRq output for
 PREEMPT_RT_FULL
References: <4E7BA334.2050003@am.sony.com> <7186.1316799377@turing-police.cc.vt.edu>
In-Reply-To: <7186.1316799377@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/11 10:36, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 22 Sep 2011 14:05:56 PDT, Frank Rowand said:
>> Change from V1 to V2:  add drivers/tty/serial/8250.c
> 
>>  drivers/tty/serial/cpm_uart/cpm_uart_core.c |    2 	1 +	1 -	0 !
>>  drivers/tty/serial/mfd.c                    |    2 	1 +	1 -	0 !
>>  drivers/tty/serial/nwpserial.c              |    2 	1 +	1 -	0 !
>>  drivers/tty/serial/omap-serial.c            |    2 	1 +	1 -	0 !
>>  drivers/tty/serial/sunhv.c                  |    4 	2 +	2 -	0 !
>>  drivers/tty/serial/sunsab.c                 |    2 	1 +	1 -	0 !
>>  drivers/tty/serial/sunsu.c                  |    2 	1 +	1 -	0 !
>>  drivers/tty/serial/sunzilog.c               |    2 	1 +	1 -	0 !
>>  drivers/tty/serial/uartlite.c               |    2 	1 +	1 -	0 !
>>  drivers/tty/serial/xilinx_uartps.c          |    2 	1 +	1 -	0 !
> 
>>  	if (up->port.sysrq)
>>  		locked = 0;
>> -	else if (oops_in_progress) {
>> +	else if (oops_in_progress || sysrq_in_progress) {
>>  		locked = spin_trylock(&up->port.lock);
>>  	} else
>>  		spin_lock(&up->port.lock);
> 
> Is it time to create a helper function for this chunk of code that appears
> in almost identical form in a dozen drivers?

Thanks for pointing that out.  The "if (up->port.sysrq)" in this pattern
already handles the case that I was trying to deal with in all of those
drivers, except cpm_uart_core.c, so I was able to remove all the other
drivers from V3 of the patch.

-Frank

