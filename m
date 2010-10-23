Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab0JWREy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 13:04:54 -0400
Received: from mxout5.netvision.net.il ([194.90.9.29]:54734 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab0JWREx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 13:04:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Message-id: <4CC3159E.3030500@nolaviz.org>
Date: Sat, 23 Oct 2010 19:04:30 +0200
From: Alon Ziv <alon@nolaviz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14)
 Gecko/20101006 Lightning/1.0b1 Thunderbird/3.0.9
To: Greg KH <gregkh@suse.de>
Cc: Alon Ziv <alon+git@nolaviz.org>, linux-usb@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>,
        Stefani Seibold <stefani@seibold.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Export usb_serial_generic_write_room for use in	other
 modules
References: <1287850818-12050-1-git-send-email-alon-git@nolaviz.org>
 <1287850818-12050-2-git-send-email-alon-git@nolaviz.org>
 <20101023163747.GA20381@suse.de>
In-reply-to: <20101023163747.GA20381@suse.de>
X-Enigmail-Version: 1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2010 06:37 PM, Greg KH wrote:
> On Sat, Oct 23, 2010 at 06:20:17PM +0200, Alon Ziv wrote:
>   
>> Any module using usb_serial_generic_write (which is already exported)
>> had better use usb_serial_generic_write_room as well.
>>     
> Are you implying that the one driver using this function today is
> broken?  Care to provide a patch for it as well?
>
>   
Well...
The one driver using it now is usb_debug, which only supports BREAK
signaling.
The generic code does not invoke the write_room callback before invoking
break_ctl, so there is no way to use this function in usb_serial.

At worst, with the current code, usb_serial's break_ctl may become a
no-op if
another BREAK signal is outstanding--which should not be an issue (assuming
regular serial protocol semantics, that is, "BREAK" has indeterminate
length).

-a

