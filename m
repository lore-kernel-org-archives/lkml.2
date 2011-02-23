Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1BWNeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:34:44 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61890 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab1BWNem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:34:42 -0500
Message-ID: <6E7634AAF813458489E0444DF71260CF@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Greg KH" <gregkh@suse.de>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Arnd Bergmann" <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, <sachi@mistralsolutions.com>,
        <davinci-linux-open-source@linux.davincidsp.com>, <nsekhar@ti.com>,
        "open list" <linux-kernel@vger.kernel.org>, <m-watkins@ti.com>,
        "Stalin Srinivasan" <stalin.s@mistralsolutions.com>
Subject: Re: [PATCH v2 13/13] tty: pruss SUART driver
Date: Wed, 23 Feb 2011 19:05:53 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Anything regarding this.

--------------------------------------------------
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Sent: Wednesday, February 23, 2011 11:00 AM
To: "Greg KH" <gregkh@suse.de>; "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Arnd Bergmann" <arnd@arndb.de>; <linux-arm-kernel@lists.infradead.org>; 
"Thomas Gleixner" <tglx@linutronix.de>; <sachi@mistralsolutions.com>; 
<davinci-linux-open-source@linux.davincidsp.com>; <nsekhar@ti.com>; "open 
list" <linux-kernel@vger.kernel.org>; <m-watkins@ti.com>; "Stalin 
Srinivasan" <stalin.s@mistralsolutions.com>
Subject: Re: [PATCH v2 13/13] tty: pruss SUART driver

> I could not follow the recommendations clearly.
> This is just to clarify.
>
> Currently, I have the following files for the suart implementation:
>
> drivers/tty/serial/da8xx_pruss/pruss_suart_api.h
> drivers/tty/serial/da8xx_pruss/pruss_suart_err.h
> drivers/tty/serial/da8xx_pruss/pruss_suart_regs.h
> drivers/tty/serial/da8xx_pruss/pruss_suart_board.h
> drivers/tty/serial/da8xx_pruss/pruss_suart_mcasp.h
> drivers/tty/serial/da8xx_pruss/pruss_suart_utils.h
>
> drivers/tty/serial/da8xx_pruss/pruss_suart_api.c
> drivers/tty/serial/da8xx_pruss/pruss_suart.c
> drivers/tty/serial/da8xx_pruss/pruss_suart_utils.c
>
> Of these, I will be removing pruss_suart_err.h as part of the Linux error 
> code cleanup.
> But, I need to keep at least  pruss_suart_board.h as a separate file, as 
> this defines
> configurations which will be often modified by users, I don't want to mix 
> it with other files.
>
> Should I combine rest of the headers into a single file ? and keep the 
> other three .c files under "drivers/tty/serial/"
> and remove the da8xx_pruss directory altogether.
>
>
> --------------------------------------------------
> From: "Greg KH" <gregkh@suse.de>
> Sent: Tuesday, February 22, 2011 8:07 PM
> To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
> Cc: "Arnd Bergmann" <arnd@arndb.de>; 
> <linux-arm-kernel@lists.infradead.org>; "Thomas Gleixner" 
> <tglx@linutronix.de>; "Alan Cox" <alan@lxorguk.ukuu.org.uk>; 
> <sachi@mistralsolutions.com>; 
> <davinci-linux-open-source@linux.davincidsp.com>; <nsekhar@ti.com>; "open 
> list" <linux-kernel@vger.kernel.org>; <m-watkins@ti.com>
> Subject: Re: [PATCH v2 13/13] tty: pruss SUART driver
>
>> On Tue, Feb 22, 2011 at 02:12:32PM +0530, Subhasish Ghosh wrote:
>>> Hello,
>>>
>>> I had kept separate files to affirm the modularity and ease of
>>> portability of the system.
>>>
>>> There are three different interfaces,
>>> 1. The Linux driver interface
>>> 2. The PRU control interface
>>> 3. The McASP serializer interface.
>>>
>>> To maintain modularity, I  had classified the files respectively as :
>>> 1.  pruss_suart.c
>>> 2.  pruss_suart_api.c
>>> 3.  pruss_suart_utils.c
>>>
>>> This is not a single device which can be expressed as a single file,
>>> but functionally different devices logically cascaded together to
>>> work in unison.
>>>
>>> We use the PRU for packet processing, but the actual data is
>>> transmitted/received through the
>>> McASP, which we use as a serializer.
>>>
>>> I feel to combine these disparate functionalities into a single file
>>> will not
>>>
>>> 1. Help better understanding the device. I mean, why should a TTY
>>> UART driver be aware of the McASP or the PRU.
>>> 2. In case of a bug in the API layer or McASP, the driver need not
>>> be touched, thus improve maintainability.
>>> 3. If we need to port it to another Linux version, just editing the
>>> driver file should suffice, this will reduce bugs while porting.
>>
>> If your code is in the kernel tree, you do not need to ever port it to a
>> new version, as it will happen automatically as new kernels are
>> released, so this really isn't anything to worry about.
>>
>>> To me, combining all of these into a single file only creates a
>>> mess. This is the reason I had separated them into different files!!
>>> I don't understand why should it be better to have all of these into
>>> a single file.
>>
>> As Alan stated, just use 3 files in the directory with the other
>> drivers, you don't need a subdir for something small like this.
>>
>> thanks,
>>
>> greg k-h
> 
