Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab2K3Cvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 21:51:49 -0500
Received: from intranet.asianux.com ([58.214.24.6]:45191 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab2K3Cvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 21:51:47 -0500
X-Spam-Score: -100.8
Message-ID: <50B81F76.8020508@asianux.com>
Date: Fri, 30 Nov 2012 10:52:38 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Suggestion] drivers/tty: drivers/char/:  for MAX_ASYNC_BUFFER_SIZE
References: <50B6E751.9000000@asianux.com> <20121129051335.GA4375@kroah.com> <50B6F967.3050000@asianux.com> <20121129183207.GA4688@kroah.com>
In-Reply-To: <20121129183207.GA4688@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年11月30日 02:32, Greg KH 写道:
> On Thu, Nov 29, 2012 at 01:57:59PM +0800, Chen Gang wrote:
>>> And, I really don't understand here, why do you want to change this?
>>> What is it going to change?  And why?
>>>
>>
>> Why:
>>   for the context MGSLPC_INFO *info in drivers/char/pcmcia/synclink_cs.c
>>     info->max_frame_size can be the value between 4096 .. 65535 (can be
>> set by its module input parameter)
>>     info->flag_buf length is 4096 (MAX_ASYNC_BUFFER_SIZE)
>>   in function rx_get_frame
>>     the framesize is limit by info->max_frame_size, but may still be
>> larger that 4096.
>>     when call function ldisc_receive_buf, info->flag_buf is equal to
>> 4096, but framesize can be more than 4096. it will cause memory over flow.
> 
> Do you use that pcmcia driver for anything?  Are those cards still
> around?

I am not use them.

I am just through code review (so it is only a suggestion).

this issue has effect with 4 synclink drivers
I checked their source code, all of them have the same issue.
  drivers/char/pcmcia/synclink_cs.c:213:        char flag_buf[MAX_ASYNC_BUFFER_SIZE];
  drivers/tty/synclink_gt.c:320:        char flag_buf[MAX_ASYNC_BUFFER_SIZE];
  drivers/tty/synclink.c:294:   char flag_buf[MAX_ASYNC_BUFFER_SIZE];
  drivers/tty/synclinkmp.c:265: char flag_buf[MAX_ASYNC_BUFFER_SIZE];

by the way, for the char_buf, has already useless (can be removed)
  drivers/tty/synclink_gt.c:321:        char char_buf[MAX_ASYNC_BUFFER_SIZE];
  drivers/tty/synclink.c:295:   char char_buf[MAX_ASYNC_BUFFER_SIZE];   
  drivers/tty/synclinkmp.c:266: char char_buf[MAX_ASYNC_BUFFER_SIZE];



> 
>> What:
>>   #define MAX_ASYNC_BUFFER_SIZE  0x10000 (instead of 4096, originally).
>>   let it match the max frame size.
>>
>> At last:
>>   my suggestion may be incorrect, need relative member (who expert about
>> it) to help checking.
> 
> That driver might be incorrect, yes, care to make up a patch for it and
> test it to verify it fixes the problem?
> 

and now Alan Cox has his own opinions
  at least, I think it is valuable to continue discussing about it.

if Alan Cox agree with it (but it seems not),  I will make patch, and try to perform test.
also welcome another members to help testing.



> thanks,
> 
> greg k-h
> 
> 


-- 
Chen Gang

Asianux Corporation
