Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab2HPNQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:16:22 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:33757 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756375Ab2HPNQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:16:18 -0400
Message-ID: <502CF2A0.8080109@c-s.fr>
Date: Thu, 16 Aug 2012 15:16:16 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Alan Cox <alan@linux.intel.com>, Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] Powerpc 8xx CPM_UART delay in receive
References: <201208141426.q7EEQSPc003956@localhost.localdomain> <20120814155227.018988da@pyramind.ukuu.org.uk>
In-Reply-To: <20120814155227.018988da@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 14/08/2012 16:52, Alan Cox a écrit :
> On Tue, 14 Aug 2012 16:26:28 +0200
> Christophe Leroy <christophe.leroy@c-s.fr> wrote:
>
>> Hello,
>>
>> I'm not sure who to address this Patch to either
>>
>> It fixes a delay issue with CPM UART driver on Powerpc MPC8xx.
>> The problem is that with the actual code, the driver waits 32 IDLE patterns before returning the received data to the upper level. It means for instance about 1 second at 300 bauds.
>> This fix limits to one byte the waiting period.
> Take a look how the 8250 does it - I think you want to set the value
> based upon the data rate. Your patch will break it for everyone doing
> high seed I/O.
>
> Alan
>
I'm not sure I understand what you mean. As far as I can see 8250/16550 
is working a bit different, as it is based on a fifo and triggers an 
interrupt as soon as a given number of bytes is received. I also see 
that in case this amount is not reached, there is a receive-timeout 
which goes on after no byte is received for a duration of more than 4 bytes.

The PowerPC CPM is working differently. It doesn't use a fifo but 
buffers. Buffers are handed to the microprocessor only when they are 
full or after a timeout period which is adjustable. In the driver, the 
buffers are configured with a size of 32 bytes. And the timeout is set 
to the size of the buffer. That is this timeout that I'm reducing to 1 
byte in my proposed patch. I can't see what it would break for high 
speed I/O.

Christophe
