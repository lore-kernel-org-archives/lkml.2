Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab2K3C0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 21:26:37 -0500
Received: from intranet.asianux.com ([58.214.24.6]:61838 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab2K3C0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 21:26:36 -0500
X-Spam-Score: -100.8
Message-ID: <50B8198D.5@asianux.com>
Date: Fri, 30 Nov 2012 10:27:25 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] drivers/tty: drivers/char/:  for MAX_ASYNC_BUFFER_SIZE
References: <50B6E751.9000000@asianux.com> <50B6ED90.6060100@asianux.com> <20121129134136.36cbf936@pyramind.ukuu.org.uk>
In-Reply-To: <20121129134136.36cbf936@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年11月29日 21:41, Alan Cox 写道:
> On Thu, 29 Nov 2012 13:07:28 +0800
> Chen Gang <gang.chen@asianux.com> wrote:
> 
>> Hello Greg Kroah-Hartman:
>>
>> for MAX_ASYNC_BUFFER_SIZE:
>>   it is defined as 4096;
>>   but for the max buffer size which it processes, is 65535.
>>   so suggest to #define MAX_ASYNC_BUFFER_SIZE 0x10000  (better than 0xffff)
> 
> I don't see the need to change this. Possibly some of the old synclink
> drivers need to check more carefully for overflows if configured for very
> large frame sizes ?
> 

I am just through code review (so it is only a suggestion), I will try to perform test.
also welcome another members to help testing.

this issue has effect with 4 synclink drivers (most of source code are the same).
  drivers/char/pcmcia/synclink_cs.c:213:	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
  drivers/tty/synclink_gt.c:320:	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
  drivers/tty/synclink.c:294:	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
  drivers/tty/synclinkmp.c:265:	char flag_buf[MAX_ASYNC_BUFFER_SIZE];

for the char_buf, has already useless (can be removed)
  drivers/tty/synclink_gt.c:321:	char char_buf[MAX_ASYNC_BUFFER_SIZE];
  drivers/tty/synclink.c:295:	char char_buf[MAX_ASYNC_BUFFER_SIZE];	
  drivers/tty/synclinkmp.c:266:	char char_buf[MAX_ASYNC_BUFFER_SIZE];


>>
>> ---------------------------------------------------------------------------------
>> Step 3:
>>
>> one sample in drivers/tty/n_gsm.c  (same for another implementation)
>>
>>   receive_buf is a function ptr which may be gsmld_receive_buf at line 2819. 
>>   it does not check the length of count whether larger than MAX_ASYNC_BUFFER_SIZE.
>>   if count is larger than MAX_ASYNC_BUFFER_SIZE, will cause issue.
> 
> Why should it - MAX_ASYNC_BUFFER_SIZE is an internal detail of the
> synclink drivers. 
> 
> Alan
> 
> 

  no, not need.  (excuse me, my English is not quite well, maybe you misunderstand what I said)

  at least, currently:
    the caller should be sure that the buffer length is enough (it seems not, I need test it).
    the internal has no duty to check it.


-- 
Chen Gang

Asianux Corporation
