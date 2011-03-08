Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab1CHSVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 13:21:46 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35580 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996Ab1CHSVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:21:44 -0500
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Mar 2011 13:21:44 EST
X-Sasl-enc: 3XBEiyuq6NMpZl63zm8XspdqIth1CnyD79SkKldrZMjP 1299607936
Message-ID: <4D76717E.2000900@fastmail.fm>
Date: Tue, 08 Mar 2011 18:12:14 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Bill Gatliff <bgat@billgatliff.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com>	<1299385050-13674-2-git-send-email-bgat@billgatliff.com>	<4D745D1F.2070808@fastmail.fm>	<AANLkTi=h0MkySh+VjrdohLzTB-NqSmmZOKcRtGRyHTg=@mail.gmail.com> <AANLkTikbW-FApSyx0FyVUCYHUG=0HS8JHpoNha0EdiZH@mail.gmail.com>
In-Reply-To: <AANLkTikbW-FApSyx0FyVUCYHUG=0HS8JHpoNha0EdiZH@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2011 17:08, Bill Gatliff wrote:
> Jack:
> 
> On Mon, Mar 7, 2011 at 10:35 AM, Bill Gatliff <bgat@billgatliff.com> wrote:
>> On Sun, Mar 6, 2011 at 10:20 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
>>>> +menuconfig GENERIC_PWM
>>>> +     tristate "PWM Support"
>>>> +     help
>>>> +       Enables PWM device support implemented via a generic
>>>> +       framework.  If unsure, say N.
>>>> +
>>>
>>> Does this need help text? Can't we just select GENERIC_PWM for the
>>> drivers / users that need it?
>>
>> That would be my preference, actually.  I'll see if I can do that at
>> the next review.
> 
> Actually, I take that back. Unlike gpiolib, the PWM API isn't
> mandatory.  So I think I'll leave this as a menuconfig.
> 
> 
> b.g.

It's up to you, of course, but I don't see why I would want to choose.

It makes life much easier for users if they only have to support one way
of talking to PWM devices and any device can be connected to any user,
with appropriate connections provided by platform data.

If you make it a depend rather than it being selected when needed then
either the driver supports multiple interfaces (which is harder to
maintain) or the person configuring the kernel has to know to build
GENERIC_PWM to get the drivers they want.

It seems much simpler to me to always use it in appropriate
drivers/users and therefore if the person configuring the kernel does
not have to know anything new and the support will only be included if
needed.

Just my £0.02,

Jack
