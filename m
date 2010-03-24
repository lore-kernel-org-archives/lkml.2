Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab0CXRqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:46:39 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:53737 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab0CXRqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tlkhdTEHisnOwhlUWSHAKKmkhqNVgRCRksHbK/1mOYoWcCd1R36JotIHn+2kTxl1sC
         HixXHMb0m7Pfd6PzTw14J9JYJtgALv6AkXewCyfHPt4Pw8WXSGtQ3QlsFKHq5o5yBYts
         xbhj+eJKHTaeta+NVMasZS+mXeh6OB6oGby2U=
MIME-Version: 1.0
In-Reply-To: <4BAA4E81.8070405@mvista.com>
References: <1269450986-3714-1-git-send-email-manuel.lauss@gmail.com>
	 <1269450986-3714-3-git-send-email-manuel.lauss@gmail.com>
	 <4BAA4E81.8070405@mvista.com>
Date: Wed, 24 Mar 2010 18:46:34 +0100
Message-ID: <f861ec6f1003241046q200bdb4ey2d2439197e63e76e@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] Alchemy: UART PM through serial framework.
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Manuel Lauss <manuel.lauss@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 6:40 PM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
> Manuel Lauss wrote:
>
>> Hook up the Alchemy on-chip uarts with the platform 8250 PM callback
>> and enable/disable the uart blocks as needed.
>>
>> Tested on Au1200.
>>
>> Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
>> ---
>>  arch/mips/alchemy/common/platform.c |   17 +++++++++++++++++
>>  arch/mips/alchemy/common/power.c    |   32
>> --------------------------------
>>  2 files changed, 17 insertions(+), 32 deletions(-)
>>
>> diff --git a/arch/mips/alchemy/common/platform.c
>> b/arch/mips/alchemy/common/platform.c
>> index 2580e77..70f4abd 100644
>> --- a/arch/mips/alchemy/common/platform.c
>> +++ b/arch/mips/alchemy/common/platform.c
>> @@ -21,6 +21,22 @@
>>  #include <asm/mach-au1x00/au1100_mmc.h>
>>  #include <asm/mach-au1x00/au1xxx_eth.h>
>>  +static void alchemy_8250_pm(struct uart_port *port, unsigned int state,
>> +                           unsigned int old_state)
>> +{
>> +       if (state == 0) {               /* power on */
>> +               __raw_writel(0, port->membase + UART_MOD_CNTRL);
>> +               wmb();
>> +               __raw_writel(1, port->membase + UART_MOD_CNTRL);
>> +               wmb();
>> +               __raw_writel(3, port->membase + UART_MOD_CNTRL);
>> +               wmb();
>> +       } else if (state == 3) {        /* power off */
>> +               __raw_writel(0, port->membase + UART_MOD_CNTRL);
>> +               wmb();
>> +       }
>> +}
>
>  A *switch* statement seems more fitting here...

Well, those are the only 2 values defined anyway, but I'll change it.

Thanks!
       Manuel Lauss
