Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab0C2N33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:29:29 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:57342 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab0C2N30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:29:26 -0400
Date: Mon, 29 Mar 2010 15:29:24 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-serial@vger.kernel.org,
       gregkh@suse.de, nios2-dev@sopc.et.ntust.edu.tw,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCHv3 2/2] serial: Add driver for the Altera UART
Message-ID: <20100329132924.GA9489@distanz.ch>
References: <cover.1267807169.git.klto@zhaw.ch> <15dc056891fb785001073bab4f9a0d0f3bf99af1.1267807169.git.klto@zhaw.ch> <a596efa5dc6130a27d045ea24174c792ee2f0bb4.1267807169.git.klto@zhaw.ch> <20100323145459.9894b1e6.akpm@linux-foundation.org> <20100324064747.GP21818@distanz.ch> <20100324070527.86d0b9b6.akpm@linux-foundation.org> <20100324162427.GQ21818@distanz.ch> <4BAAB431.3040202@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAAB431.3040202@wytron.com.tw>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-03-25 at 01:54:09 +0100, Thomas Chou <thomas@wytron.com.tw> wrote:
> On 03/25/2010 12:24 AM, Tobias Klauser wrote:
>> On 2010-03-24 at 12:05:27 +0100, Andrew Morton<akpm@linux-foundation.org>  wrote:
>>    
>>> On Wed, 24 Mar 2010 07:47:47 +0100 Tobias Klauser<tklauser@distanz.ch>  wrote:
>>>      
>>>> On 2010-03-23 at 22:54:59 +0100, Andrew Morton<akpm@linux-foundation.org>  wrote:
>>>>        
>>>>> On Fri,  5 Mar 2010 17:52:23 +0100
>>>>> Tobias Klauser<tklauser@distanz.ch>  wrote:
>>>>>
>>>>>          
>>>>>> +	sigs |= (altera_uart_getppdcd(port->line) ? TIOCM_CD : 0);
>>>>>> +	sigs |= (altera_uart_getppdtr(port->line) ? TIOCM_DTR : 0);
>>>>>>            
>>>>> We seem to be missing a few things here.
>>>>>
>>>>> drivers/serial/altera_uart.c: In function 'altera_uart_get_mctrl':
>>>>> drivers/serial/altera_uart.c:100: error: implicit declaration of function 'altera_uart_getppdcd'
>>>>> drivers/serial/altera_uart.c:101: error: implicit declaration of function 'altera_uart_getppdtr'
>>>>> drivers/serial/altera_uart.c: In function 'altera_uart_set_mctrl':
>>>>> drivers/serial/altera_uart.c:114: error: implicit declaration of function 'altera_uart_setppdtr'
>>>>>          
>>>> These should usually be declared in a board specific header. There were
>>>> compatibility macros in altera_uart.c which defined them to NOPs in case
>>>> the board header did not properly define them. But I remove them as per
>>>> request by Alan Cox (Message-ID: 20100301181920.3952c3e7@lxorguk.ukuu.org.uk).
>>>>
>>>> Should we add them again (maybe to altera_uart.h)? Or would it be better
>>>> to define a config symbol which is set in the board specific Kconfig and
>>>> altera_uart depends on it?
>>>>        
>>> I guess the latter.
>>>
>>> There should have been a real implementation of these in the patchset -
>>> otherwise the code can't be used or tested.  Confused.
>>>      
>> Sorry for the confusion.
>>
>> The last patchset I submitted (with the functions removed from
>> altera_uart.c) was tested on a local branch, where I added the macros to
>> a global board specific header. I didn't include that one in the patch.
>>
>> After looking at the code and it's history a bit closer (and also on the
>> nios2 specific part) I realised that this macro was probably added
>> because the driver was originally based on drivers/serial/mcf.c (the
>> macros are present there too).
>>
>> Also there are currently no board configurations known to me that define
>> these macros. So I'd suggest to remove the usage of these macros
>> alltogether. We could still add them again (to the board specific part
>> and with the config option then) in case there will be a board
>> configuration implementing DTR/DCD lines on GPIOs.
>>
>> Could anyone on nios2-dev verify that there are currently no such board
>> configurations?
>>
>> I'd remove the usage of the macros then and post an updated patch.
>>    
> Maybe we can add pointers to functions for the DCD/DTR in the struct  
> altera_uart_platform_uart. Then board config file can define them if  
> they implement these pins, NULL/0 otherwise.

Unfortunately we then need to define them in struct altera_uart too and
set them in the probe function using the platform data.

For me that seems like a bit too much overhead just to support the
possibility of someone defining these functions in the future. I'd
prefer to get rid of the macros now for the mainline submission and then
add it later if someone would actually use these DCD/DTR get/set
functions. Hope that's OK for you too, Thomas.

-- Tobias
