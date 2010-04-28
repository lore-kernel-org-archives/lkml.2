Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0D1LlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:41:06 -0400
Received: from 007.netroom.de ([194.0.247.207]:19917 "EHLO 007.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab0D1LlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 07:41:04 -0400
Message-ID: <4BD81ED5.1050408@draisberghof.de>
Date: Wed, 28 Apr 2010 13:41:09 +0200
From: Josua Dietze <digidietze@draisberghof.de>
Reply-To: digidietze@draisberghof.de
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Daniel Mack <daniel@caiaq.de>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: USB gadget with drivers "on board"
References: <Pine.LNX.4.44L0.1004261531480.1764-100000@iolanthe.rowland.org> <4BD5F43E.4090404@draisberghof.de> <op.vbu6nahq7p4s8u@pikus>
In-Reply-To: <op.vbu6nahq7p4s8u@pikus>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michał Nazarewicz schrieb:
> On Mon, 26 Apr 2010 22:14:54 +0200, Josua Dietze 
> <digidietze@draisberghof.de> wrote:
> 
>> Important for the Linux handling is that "mode 1" is clearly
>> distinguishable from "mode 2", either by using a different product ID
>> or by setting a different class for the device or interface 0 (will
>> most likely be "8" for the install mode).
> 
> So it will be enough to change the USB device class for the zeroth
> interface for udev to recognise the mass storage to be ejected?  Note
> that I will use mass storage in the second mode as well.

This is often the case with the common "zero-cd" devices, but 
they have the storage on upper interface numbers after switching.

The point is to enable udev or any other tool to distinguish 
between "unswitched" and "switched"; otherwise the procedure 
for switching will be executed on *both* modes which might 
disturb the device or the system.

A change in one of the attributes like iProduct or iSerial 
could be detected as well of course.

> Also, I think that it might be a good idea to make some "standardised"
> mechanism for all such devices so that a generic udev code could be
> written.  Adding things to the descriptors may be difficult in a way,
> but maybe adding "[NoCD]" to the interface name would be enough.

That is up to the (countless) manufacturers of course; on the 
other hand, the Windows drivers need to recognize the mode as 
well so there should always be one way or the other to 
accomplish that.


Josua Dietze
