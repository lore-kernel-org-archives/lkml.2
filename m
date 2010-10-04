Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab0JDNYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 09:24:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41478 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab0JDNYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 09:24:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=eM3EeQ2/agRGhnNHmYevKzx5i96OjRjuz+In1bog2P+CVDRVBHk3ArsNjpQZUy+cz3
         OPkfOd1i93HVph+aRqVwq28kwxGEm+Vh3bSdjxn+7BgNwpIay33fIq/UIzKURl4dBceH
         Rcc/wrtd1apFwCw9AivEUu16623J/VIg4ASto=
MIME-Version: 1.0
In-Reply-To: <20101004122214.GA5692@bicker>
References: <1286135940-2364-1-git-send-email-rahul.ruikar@gmail.com> <20101004122214.GA5692@bicker>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Mon, 4 Oct 2010 18:54:00 +0530
Message-ID: <AANLkTi=K25BbWjsnVNny-9YOVEE1xNsDFMoMfc+P8sWQ@mail.gmail.com>
Subject: Re: [RESEND/PATCH] usb: gadget: goku_udc: Fix error path
To: Dan Carpenter <error27@gmail.com>, Rahul Ruikar <rahul.ruikar@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, nm127@freemail.hu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan,

Following things I tried to do with this change.
there can be 3 cases where one need to handle device_register()
1) reaching error path but device_register() is never called..( ie,
error occurred before calling device_register() function call, in this
case "dev->reg_status" will have value "0" and in error handler
device_unregister() or put_device() will not be called.

2) error occurred at device_register() ( ie. it fails and calls error
handler, this way "dev->reg_status" will have value "2" and in error
handler, based on this value "put_device() will be called.

3) error occured after device_register() success. ( ie, error occured
due to some other function, ) in this case "dev->reg_status" will have
value "1" and in error handler, based on this value
"device_unregister" will be called.

but anyways someone has now proposed to change it to new usb
interface, so this patch is of no use now.

Thanks
Rahul Ruikar





On 4 October 2010 17:52, Dan Carpenter <error27@gmail.com> wrote:
> On Mon, Oct 04, 2010 at 01:29:00AM +0530, Rahul Ruikar wrote:
>> call put_device() when device_register() fails.
>>
>
> Sorry I didn't realize what you were trying to do here.  This is not
> correct at all.
>
> The right thing is to fix device_register() to call put_device() itself.
> It's a bit involved, because all the callers will need to be audited but
> someone is working on this I think.
>
> regards,
> dan carpenter
>
>
