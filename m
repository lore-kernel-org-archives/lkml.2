Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab0CSANm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:13:42 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:44058 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab0CSANk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:13:40 -0400
Message-ID: <4BA2C1AF.7010205@oracle.com>
Date: Thu, 18 Mar 2010 17:13:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Input <linux-input@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [RFC] Input: implement sysrq as an input handler
References: <20100317061952.GA19789@core.coreip.homeip.net>
In-Reply-To: <20100317061952.GA19789@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B020A.4BA2C1B1.017B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/10 23:19, Dmitry Torokhov wrote:
> Instead of keeping SysRq support inside of legacy keyboard driver split
> it out into a separate input handler (filter). This stops most SysRq input
> events from leaking into evdev clients (some events, such as first SysRq
> scancode - not keycode - event, are still leaked into both legacy keyboard
> and evdev).
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
>  drivers/char/keyboard.c |   40 +-------
>  drivers/char/sysrq.c    |  222 +++++++++++++++++++++++++++++++++++++++++------
>  include/linux/sysrq.h   |   23 +----
>  kernel/sysctl.c         |   23 +++++
>  4 files changed, 224 insertions(+), 84 deletions(-)


> +/* Simple translation table for the SysRq keys */
> +static const unsigned char sysrq_xlate[KEY_MAX + 1] =
> +        "\000\0331234567890-=\177\t"                    /* 0x00 - 0x0f */
> +        "qwertyuiop[]\r\000as"                          /* 0x10 - 0x1f */
> +        "dfghjkl;'`\000\\zxcv"                          /* 0x20 - 0x2f */
> +        "bnm,./\000*\000 \000\201\202\203\204\205"      /* 0x30 - 0x3f */
> +        "\206\207\210\211\212\000\000789-456+1"         /* 0x40 - 0x4f */
> +        "230\177\000\000\213\214\000\000\000\000\000\000\000\000\000\000" /* 0x50 - 0x5f */
> +        "\r\000/";                                      /* 0x60 - 0x6f */

We are running out of these precious sysrq keys.
Do you have any ideas of how to have a larger xlate table?

-- 
~Randy
