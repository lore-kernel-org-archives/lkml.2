Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1ATG6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 01:58:04 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56843 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab1ATG6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 01:58:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ChjYu1LYN4oE+QZxna0gB0eS0xK1e8QFmsAY5VBScj57ASdo01YwBi7jphO+WL6ViC
         uAQqn+BvwTLx+RMpplyquxh/wX/Wf30OMQuOsV7SHgwdGjH+auGZzfCTU/CUR4S77H7j
         dMQMXP3eXMeZ6Y9f58f0sYVmF5ElMRyreNq5I=
Message-ID: <4D37DCFE.3080004@gmail.com>
Date: Thu, 20 Jan 2011 07:58:06 +0100
From: Thomas Weber <thomas.weber.linux@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101220 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Govindraj <govindraj.ti@gmail.com>
CC: Thomas Weber <weber@corscience.de>,
        "G, Manjunath Kondaiah" <manjugk@ti.com>, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        "Govindraj.R" <govindraj.raja@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrei Emeltchenko <andrei.emeltchenko@nokia.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] OMAP: Enable Magic SysRq on serial console ttyOx
References: <1295426461-12459-1-git-send-email-weber@corscience.de> <AANLkTin0-joNuqxqL79j0wqPk_A5mtAgzEY=X=PeH=+C@mail.gmail.com> <20110119130049.GB9365@m-desktop> <4D36E7CC.5090303@corscience.de> <AANLkTikjdukQ+kUUR7N11rZ5b=Xd=xLb0-chMrbp5BQ6@mail.gmail.com>
In-Reply-To: <AANLkTikjdukQ+kUUR7N11rZ5b=Xd=xLb0-chMrbp5BQ6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.01.2011 14:58, schrieb Govindraj:
> On Wed, Jan 19, 2011 at 7:01 PM, Thomas Weber <weber@corscience.de> wrote:
>> Am 19.01.2011 14:00, schrieb G, Manjunath Kondaiah:
>>> On Wed, Jan 19, 2011 at 03:01:39PM +0530, Govindraj wrote:
>>>> On Wed, Jan 19, 2011 at 2:11 PM, Thomas Weber <weber@corscience.de> wrote:
>>>>> Magic SysRq key is not working for OMAP on new serial
>>>>> console ttyOx because SUPPORT_SYSRQ is not defined
>>>>> for omap-serial.
>>>>>
>>>>> This patch defines SUPPORT_SYSRQ in omap-serial and
>>>>> enables handling of Magic SysRq character.
>>>>>
>>>>> Signed-off-by: Thomas Weber <weber@corscience.de>
>>>>
>>>> Looks fine to me.
>>>>
>>>> Acked-by: Govindraj.R <govindraj.raja@ti.com>
>>> I tried to use SysRq key on minicom after applying this patch, it looks
>>> like it is not triggering sysrq event.
>>>
>>> Am I missing anything?
>>>
>>> -Manjunath
>>> --
>> Hello Manjunath,
>>
>> Do you have CONFIG_MAGIC_SYSRQ enabled?
>> Magic SysRq key in Kernel Hacking
>>
>> I tested it on Devkit8000 (beagle board clone).
>>
> 
> re-setting lsr_break_flag to 0 in receive chars is causing issues
> in getting sysrq key break sequence on omap-serial.c
> 
> Manju,
> 
> can you try this change on your environment.
> With below change works for me on 3430SDP/4430SDP.
> key sequence I checked.
> [alt + b + t]  => shows trace of tasks running.
> [alt + b + b] => system reboot.
> 
> 
> diff --git a/drivers/serial/omap-serial.c b/drivers/serial/omap-serial.c
> index 1201eff..6df623e 100644
> --- a/drivers/serial/omap-serial.c
> +++ b/drivers/serial/omap-serial.c
> @@ -20,6 +20,10 @@
>   * this driver as required for the omap-platform.
>   */
> 
> +#if defined(CONFIG_SERIAL_OMAP_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
> +#define SUPPORT_SYSRQ
> +#endif
> +
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/console.h>
> @@ -190,7 +194,6 @@ static inline void receive_chars(struct
> uart_omap_port *up, int *status)
>                         if (up->port.line == up->port.cons->index) {
>                                 /* Recover the break flag from console xmit */
>                                 lsr |= up->lsr_break_flag;
> -                               up->lsr_break_flag = 0;
>                         }
>  #endif
>                         if (lsr & UART_LSR_BI)
> 
> 
> --
> Thanks,
> Govindraj.R
> --

Hello,

both version works for me.

Thomas

