Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760707Ab2CON7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 09:59:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42914 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759361Ab2CON7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 09:59:05 -0400
Message-ID: <4F61F554.1010302@mvista.com>
Date: Thu, 15 Mar 2012 17:57:40 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Yongsul@vger.kernel.org, Oh@vger.kernel.org
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "yongsul96.oh@samsung.com" <yongsul96.oh@samsung.com>
Subject: Re: [PATCH] USB: Gadget: Composite: Added error handling codes to
 prevent a memory leak case when the configuration's bind function failed
References: <1331774635-21217-1-git-send-email-yongsul96.oh@samsung.com>
In-Reply-To: <1331774635-21217-1-git-send-email-yongsul96.oh@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 15-03-2012 5:23, Yongsul@vger.kernel.org wrote:

> From: yongsul96.oh@samsung.com<yongsul96.oh@samsung.com>

>   In some usb gadget driver, for example usb gadget serial driver(serial.c),
> multifunction composite driver(multi,c), nokia composite gadget driver(nokia.c),
> HID composite driver(hid.c), CDC composite driver(cdc2.c).., the configuration's
> bind function by called the 'usb_add_config()' has multiple bind config functions
> for each functionality, for example cdc2 configuration bind function -'cdc_do_config()'
> has two functionality bind config functions -'ecm_bind_config()'&  'acm_bind_config()'
> in CDC composite driver.
>   In each functionality bind config function, new instance for each functionality is
> allocated&  initialized by 'kzalloc()' ,and finally the new instance is added by
> 'usb_add_function()'. After 'usb_add_function' state, already created the instance
> is only handled by its configuration&  freed from functionality unbind function.
>   So, If an error occurred during the second functionality bind config state, for example
> an error occurred at 'acm_bind_config()' after succeeding 'ecm_bind_function()',
> The created instance by 'acm_bind_config()' cannot be freed.
> And it makes memory leak situation.

> This patch fixes this issue.

> Signed-off-by: yongsul96.oh@samsung.com <yongsul96.oh@samsung.com>

    Real name is required on the left, not another copy of email.

WBR, Sergei
