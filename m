Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab0GOPKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:10:34 -0400
Received: from mail.tmr.com ([64.65.253.246]:43796 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933421Ab0GOPKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:10:33 -0400
Message-ID: <4C3F24E6.9000002@tmr.com>
Date: Thu, 15 Jul 2010 11:10:30 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Ed W <lists@wildgooses.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Raise initial congestion window size / speedup slow start?
References: <4C3D94E3.9080103@wildgooses.com> <4C3DD5EB.9070908@tmr.com> <4C3E02D7.3080500@wildgooses.com>
In-Reply-To: <4C3E02D7.3080500@wildgooses.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ed W wrote:
>
>>> Does someone have some pointers on where to look to modify initial 
>>> congestion window please?
>>>
>> Are you sure that's the issue? The backlog is in incoming, is it not?
>
> Well, I was simplifying a little bit, actually I have a bunch of 
> protocols in use, http is one of them
>
>
>> Having dealt with moderately long delays push TB between timezones, 
>> have you set your window size up? Set 
>> /proc/sys/net/ipv4/tcp_adv_win_scale to 5 or 6 and see if that helps. 
>> You may have to go into /proc/sys/net/core and crank up the rmem_* 
>> settings, depending on your distribution.
>>
>> This allows the server to push a lot of data without an ack, which is 
>> what you want, the ack will be delayed by the long latency, so this 
>> helps.
>
> I think I'm misunderstanding something fundamental here:
>
> - Surely the limited congestion window is what throttles me at 
> connection initialisation time and this will not be affected by 
> changing the params you mention above?  For sure the sliding window 
> will be relevant vs my bandwidth delay product once the tcp connection 
> reaches steady state, but I'm mostly worried here about performance 
> right at the creation of the connection?
>
> - Both you and Alan mention that the bulk of the traffic is "incoming" 
> - this implies you think it's relevant?  Obviously I'm missing 
> something fundamental here because my understanding is that the 
> congestion window shuts us down in both directions (at the start of 
> the connection?)
>
> Thanks for the replies - I will take it over to netdev
>
Perhaps they will give you an answer you like better.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

