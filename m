Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab1EKQSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:18:21 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:34006 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757413Ab1EKQSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:18:17 -0400
Message-ID: <4DCA4C29.20403@st.com>
Date: Wed, 11 May 2011 14:13:21 +0530
From: Amit Virdi <amit.virdi@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "samuel@sortiz.org" <samuel@sortiz.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Viresh KUMAR <viresh.kumar@st.com>
Subject: Re: sleeping function called from invalid context
References: <4DC8CF50.4040003@st.com> <20110510103256.58d61861@bob.linux.org.uk>
In-Reply-To: <20110510103256.58d61861@bob.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Alan,

On 5/10/2011 3:02 PM, Alan Cox wrote:
>> On analysis, I found that this is due to the change introduced in
>> tty_ioctl.c where the termios mutex is taken to protect against
>> parallel throttle/unthrottle. Probably IrCOMM stack code wasn't
>> tested before merging this patch.
>>
>> Please suggest what should be done with the IrCOMM protocol stack
>> code to resolve this problem?
>
> It looks like the comments are wrong
>
>          /*
>           * Just give it over to the line discipline. There is no need to
>           * involve the flip buffers, since we are not running in an
>          interrupt
>           * handler
>           */
>
>
> appears to be completely untrue
>
> I suspect it just needs to use the tty_flip_buffer functions properly
> instead of trying to do clever shortcuts
>
>
> 	tty_insert_flip_string(self->tty, skb->data, skb->len);
> 	tty_flip_buffer_push(self->tty);
>
> .
>

I incorporated the change suggested by you and tested the stack again. 
It is working perfectly fine - no stack trace is printed now. I'll be 
sending the patch soon.

Thanks n Regards
Amit Virdi
