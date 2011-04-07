Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab1DGSyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 14:54:32 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.29]:49898 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561Ab1DGSyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 14:54:31 -0400
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Apr 2011 14:54:30 EDT
Message-ID: <4D9E04F0.5010004@ronetix.at>
Date: Thu, 07 Apr 2011 21:39:44 +0300
From: RONETIX - Asen Dimov <dimov@ronetix.at>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        Mike Frysinger <vapier@gentoo.org>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        linux-arm-msm@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] drivers: char: hvc: add arm JTAG DCC console support
References: <1291145141-18301-1-git-send-email-dwalker@codeaurora.org>
In-Reply-To: <1291145141-18301-1-git-send-email-dwalker@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Df-Sender: [pbs]ZGltb3ZAcm9uZXRpeC5hdA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/30/2010 09:25 PM, Daniel Walker wrote:
> This driver adds a basic console that uses the arm JTAG
> DCC to transfer data back and forth. It has support for
> ARMv6 and ARMv7.
>
> This console is created under the HVC driver, and should be named
> /dev/hvcX (or /dev/hvc0 for example).
>
> Cc: Tony Lindgren<tony@atomide.com>
> Cc: Arnd Bergmann<arnd@arndb.de>
> Cc: Nicolas Pitre<nico@fluxnic.net>
> Cc: Greg Kroah-Hartman<gregkh@suse.de>
> Cc: Mike Frysinger<vapier@gentoo.org>
> Signed-off-by: Daniel Walker<dwalker@codeaurora.org>
> ---
>   drivers/char/Kconfig   |    9 +++
>   drivers/char/Makefile  |    1 +
>   drivers/char/hvc_dcc.c |  133 ++++++++++++++++++++++++++++++++++++++++++++++++
...

this DCC driver implements "one channel", but what about implementing
"multiple channels". For example reserve few(3) bits for channel number,
and two bits for carried data, then fill the rest bytes with with some data
and send the word(32 bits) over DCC. On the Linux side writing on /dev/hvcX
puts the number X as channel number, and on the other side the CPU
emulator gets the data and redistribute it to TCP/IP socket.

I have started write some code implementing this. Are there any one 
interested
in this multiple channels, and are there any one started to work on it?


Regards,
Asen
