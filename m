Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2LCCUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 21:20:05 -0500
Received: from intranet.asianux.com ([58.214.24.6]:40444 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab2LCCUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 21:20:02 -0500
X-Spam-Score: -100.8
Message-ID: <50BC0C84.4060802@asianux.com>
Date: Mon, 03 Dec 2012 10:20:52 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Fulghum <paulkf@microgate.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] synclink fix ldisc buffer argument
References: <50B6E751.9000000@asianux.com> <20121129051335.GA4375@kroah.com> <50B6F967.3050000@asianux.com> <20121129183207.GA4688@kroah.com> <50B81F76.8020508@asianux.com> <50B8DDAC.8070901@microgate.com> <50B90D0D.9040401@microgate.com> <20121202151332.3b6a6504@pyramind.ukuu.org.uk> <F6B8A325-7DBF-4623-B16C-CDC5642EFD16@microgate.com> <20121202181057.097012c6@pyramind.ukuu.org.uk> <989CB961-79F8-479B-B16C-41358A60AC94@microgate.com>
In-Reply-To: <989CB961-79F8-479B-B16C-41358A60AC94@microgate.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年12月03日 04:05, Paul Fulghum 写道:
> OK, I’ll do that.
> 

pardon (I am just learning)
  does 65535 mean HDLC_MAX_FRAME_SIZE ?
  why do we need info->max_frame_size >= 4096 ?

in drivers/tty/synclink_gt.c:
3550         if (info->max_frame_size < 4096)
3551                 info->max_frame_size = 4096;
3552         else if (info->max_frame_size > 65535)
3553                 info->max_frame_size = 65535;
3554
 ...
3603                 info->max_frame_size = 4096;


if possible:
  can we move the relative comments (which are inside function) to the
location just above ldisc_receive_buf ?


  thanks.

gchen.


> On Dec 2, 2012, at 12:10 PM, Alan Cox <alan@lxorguk.ukuu.org.uk
> <mailto:alan@lxorguk.ukuu.org.uk>> wrote:
> 
>> On Sun, 2 Dec 2012 10:11:58 -0600
>> Paul Fulghum <paulkf@microgate.com <mailto:paulkf@microgate.com>> wrote:
>>
>>> True, in this mode line disciplines other than N_HDLC would not be
>>> functional and N_HDLC ignores the flag buffer.
>>> This change won’t make other line disciplines useful, it will just
>>> prevent the case of a mistakenly selected line discipline accessing
>>> beyond the end of the (dummy) flag buffer.
>>>
>>> I’m fine with or without the change. It is functional now with a
>>> chance to read past then end of a buffer if misconfigured. With the
>>> change, it has the same functionality without the ability to read
>>> past the end of a buffer if misconfigured.
>>
>> With the change its feeding crap in the flags buffer, which may matter in
>> future depending what happens to the other bits.
>>
>> If this is a real issue far better to just kzalloc a blank flag buffer to
>> match the mtu.
>>
> 
> -- 
> Paul Fulghum
> MicroGate Systems, Ltd.
> =Customer Driven, by Design=
> (800)444-1982
> (512)345-7791 (Direct)
> (512)343-9046 (Fax)
> Central Time Zone (GMT -5h)
> www.microgate.com <http://www.microgate.com/>
> 


-- 
Chen Gang

Asianux Corporation
