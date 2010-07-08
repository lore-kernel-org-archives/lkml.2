Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0GHJEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 05:04:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43289 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab0GHJEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 05:04:36 -0400
Message-ID: <4C35945F.9050502@ru.mvista.com>
Date: Thu, 08 Jul 2010 13:03:27 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Patrick Pannuto <ppannuto@codeaurora.org>, dbrownell@users.sourceforge.net,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       sboyd@codeaurora.org
Subject: Re: [PATCH] usb: gadget: #include device.h in gadget.h
References: <4C35200C.2040209@codeaurora.org> <20100708033420.GA24135@suse.de>
In-Reply-To: <20100708033420.GA24135@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Greg KH wrote:

>> gadget.h uses structures defined in device.h, it must include it. In
>> most cases, gadget.h is preceded by linux/platform_device.h, but if
>> you are grouping headers sanely, device.h may not be pulled in until
>> *after* gadget (e.g. mach/msm_device.h), thus gadget.h should not
>> rely on something else #including device.h

    As well as a number of other headers. I have postaed a patch addressing 
the missing #include's already.

>> include/linux/usb/gadget.h:488: error: field 'dev' has incomplete type

> Why not just provide an "empty" prototype for whatever is needed.

    Empty prototype of what, 'struct device'? Have you looked at the code at all?

struct usb_gadget {
	/* readonly to gadget driver */
	const struct usb_gadget_ops	*ops;
	struct usb_ep			*ep0;
	struct list_head		ep_list;	/* of usb_ep */
	enum usb_device_speed		speed;
	unsigned			is_dualspeed:1;
	unsigned			is_otg:1;
	unsigned			is_a_peripheral:1;
	unsigned			b_hnp_enable:1;
	unsigned			a_hnp_support:1;
	unsigned			a_alt_hnp_support:1;
	const char			*name;
	struct device			dev;
};

    How this is going to work with "empty prototype"?.

> Generally, having header files include header files is frowned apon, and
> a number of people have been working on slowly unwinding a lot of this
> type of mess that we currently have.

    IMO they could put their time to better use.

>> include/linux/usb/gadget.h: In function 'set_gadget_data':
>> include/linux/usb/gadget.h:492:
>> 	error: implicit declaration of function 'dev_set_drvdata'

> Ick, but then, this gets messier.

    What gets messier?

> How about just fixing up the .c file that the problem happens in, to
> include device.h first?  Is this an issue in the current tree somehow?

    In my opinion, this is just insane approach.

> thanks,
> greg k-h

WBR, Sergei

