Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab0IUR7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:59:18 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38548 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043Ab0IUR7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:59:16 -0400
Message-ID: <4C98F245.2000002@ru.mvista.com>
Date: Tue, 21 Sep 2010 21:58:29 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Ott <alan@signal11.us>
CC: Jiri Kosina <jkosina@suse.cz>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] Don't Send Feature Reports on Interrupt Endpoint
References: <ba7172472e7fa92f305c16ab3456da18.squirrel@host171.canaca.com> <4C98EAAE.3020409@signal11.us>
In-Reply-To: <4C98EAAE.3020409@signal11.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Ott wrote:

> Feature reports should only be sent on the control endpoint.

> The USB HID standard is unclear and confusing on this issue. It seems to
> suggest that Feature reports can be sent on a HID device's Interrupt OUT
> endpoint. This cannot be the case because the report type is not
> encoded in transfers sent out the Interrput OUT endpoint. If Feature 
> reports were sent on the Interrupt OUT endpint, they would be 
> indistinguishable from Output reports in the case where Report IDs were 
> not used.

> Further, Windows and Mac OS X do not send Feature reports out the 
> interrupt OUT Endpoint. They will only go out the Control Endpoint.

> In addition, many devices simply do not hande Feature reports sent out 
> the Interrupt OUT endpoint.

> Reported-by: simon@mungewell.org
> Signed-off-by: Alan Ott <alan@signal11.us>
> ---
>  drivers/hid/usbhid/hid-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index b729c02..b0ccc42 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -807,7 +807,7 @@ static int usbhid_output_raw_report(struct 
> hid_device *hid, __u8 *buf, size_t co
>      struct usb_host_interface *interface = intf->cur_altsetting;
>      int ret;

    It's high time to add an empty line here...

>  -    if (usbhid->urbout) {

    The patch is damaged -- something inserted spaces at the start of lines...

WBR, Sergei
