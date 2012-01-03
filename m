Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2ACMTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 07:19:22 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:51679 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668Ab2ACMTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 07:19:20 -0500
X-Sasl-enc: YwOyRZFAXjg37YlML4noF+XbdHavntAMY83IWZgTJF6p 1325593159
Message-ID: <4F02F244.6040902@fastmail.fm>
Date: Tue, 03 Jan 2012 12:19:16 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org> <4F0220F5.30309@fastmail.fm> <20120103004220.084d61f3@pyramind.ukuu.org.uk> <201201031257.47265.oliver@neukum.org>
In-Reply-To: <201201031257.47265.oliver@neukum.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/12 11:57, Oliver Neukum wrote:
> Am Dienstag, 3. Januar 2012, 01:42:20 schrieb Alan Cox:
>> In that case however you don't want some generic firmware module knowing
>> all this crap, your driver can just request_firmware() the stuff as
>> modprobe and free it up on the module unload. For a typical 8bit firmware
>> of a few K you'll free a ton more memory unloading the module than the
>> firmware ! That I think actually covers the majority of devices under
>> discussion.
> 
> I am afraid it doesn't, at least not fully.
> We have many devices whose primary (operational) driver does not load
> the firmware. That job is left to a secondary driver or user space.
> 
> We could leave those secondary drivers and their firmware in RAM after
> their primary usage and except for a few pathological cases (which
> can be solved with a few udev rules preventively loading drivers) we'd
> be good, but we lack a mechanism for switching to a seconary driver
> and back during resumption.

You don't mension the bus used so I'm going to use USB as an example.

As I understand it the majority of devices that need firmware have two
different identities: the "bootstrap" id and the "primary" id. If we
always make sure we have the drivers for both bootsrap and primary ids
loaded then we should have the firmware in memory. If the device has
lost its firmware then it will reregister with the bootstrap id
otherwise it will continue with the primary id. Either way the correct
driver should pick it up and handle it.

That said, I guess there are more complicated / difficult pieces of
hardware that might not do that. Is that the case here? Can we detect
that the firmware needs reloading and have the primary driver "yield" to
the firmware driver?

Thanks,

Jack

