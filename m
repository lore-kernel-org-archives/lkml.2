Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab0JXSL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 14:11:26 -0400
Received: from mxout5.netvision.net.il ([194.90.9.29]:61702 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab0JXSLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 14:11:25 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Message-id: <4CC476B1.6090409@nolaviz.org>
Date: Sun, 24 Oct 2010 20:10:57 +0200
From: Alon Ziv <alon@nolaviz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14)
 Gecko/20101006 Lightning/1.0b1 Thunderbird/3.0.9
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>, Alon Ziv <alon+git@nolaviz.org>,
        linux-usb@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Stefani Seibold <stefani@seibold.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Export usb_serial_generic_write_room for use in other
 modules
References: <1287850818-12050-1-git-send-email-alon-git@nolaviz.org>
 <1287850818-12050-2-git-send-email-alon-git@nolaviz.org>
 <20101023163747.GA20381@suse.de> <4CC3159E.3030500@nolaviz.org>
 <20101024093701.67850d1b@lxorguk.ukuu.org.uk>
In-reply-to: <20101024093701.67850d1b@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2010 10:37 AM, Alan Cox wrote:

>> The generic code does not invoke the write_room callback before invoking
>> break_ctl, so there is no way to use this function in usb_serial.
>>     
> Why would it ?
>
>   
Oops, typo...  Last sentence was supposed to end with "in usb_debug".
usb_debug invokes usb_serial_generic_write from break_ctl and ignores
the result; therefore, if there is no room in the generic write FIFO,
the write will fail.  However--usb_debug _only_ uses
usb_serial_generic_write for break_ctl; so if there is no room, it is
because of a previous (uncompleted) break_ctl, and according to standard
UART semantics there is no difference between one break and two...

-a
