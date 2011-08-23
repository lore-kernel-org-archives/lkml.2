Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab1HWSo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:44:56 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4919 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1HWSou convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:44:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:date:
	mime-version:content-transfer-encoding:from:organization:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=svye6ZhfQlByrkP1WSmYJNMPgIHjNaevs4A8Gfvdj9D8Wb7MPN07lIEFIULOVSIsf
	QDoEpl5zbigngYqYPfCkw==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
References: <op.v0n67imkvgw7ix@mnazarewicz-glaptop>
 <Pine.LNX.4.44L0.1108231030270.2069-100000@iolanthe.rowland.org>
 <20110823145759.GM1341@legolas.emea.dhcp.ti.com>
 <op.v0n9l9h9vgw7ix@mnazarewicz-glaptop>
 <20110823151105.GP1341@legolas.emea.dhcp.ti.com>
 <op.v0oaia2bvgw7ix@mnazarewicz-glaptop>
 <20110823171942.GC10996@legolas.emea.dhcp.ti.com>
Date: Tue, 23 Aug 2011 20:44:33 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Message-ID: <op.v0ojojhgvgw7ix@mnazarewicz-glaptop>
In-Reply-To: <20110823171942.GC10996@legolas.emea.dhcp.ti.com>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Tue, 23 Aug 2011 17:11:06 +0200, Felipe Balbi <balbi@ti.com> wrote:
>>> I'm trying to think if this is really what we want. This might mean
>>> $current_config will be different depending if we connect it to SS, HS
>>> or FS hubs.

> On Tue, Aug 23, 2011 at 05:26:24PM +0200, Michal Nazarewicz wrote:
>> What do you mean by $current_config?  The bConfigurationValue will be

On Tue, 23 Aug 2011 19:19:43 +0200, Felipe Balbi <balbi@ti.com> wrote:
> the currently chosen configuration.

So yes, it potentially ma be different depending on the speed.

>> the same for "the same" configuration regardless of speed but different
>> configurations may be available for different speeds and "the same"
>> configuration in various speeds might have different functions.
>>
>> So just for the sake of having something concrete, let's say we have:
>>
>> Configuration #1 with
>>   function A supporting FS and HS and

> my question is what happens with the HS support on function A
> (descriptors, endpoints, etc) when you connect it to a HS hub or to a FS
> hub.

When you connect it to HS hub you get it's HS descriptors (and FS  
descriptors
if you request “other speed descriptors”).  When you connect it to FS hub  
you
get it's FS descriptors.

>>   function B supporting FS only.
>> Configuration #2 with
>>   function B supporting FS only.
>> Configuration #3 with
>>   function A supporting FS and HS and
>>   function C supporting HS only (dunno if that makes sense).
>>
>> When connected to FS hub, we will return the following:
>>
>> Configuration #1: A, B
>> Configuration #2: B
>> Configuration #3: A
>>
>> When connect to HS hub, we will return the following:
>>
>> Configuration #1: A
>
> See, I'm not sure this is allowed by USB spec. But I could be wrong. (I
> mean having a function disappear)

I'm hardly an expert so I cannot address that concern.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
