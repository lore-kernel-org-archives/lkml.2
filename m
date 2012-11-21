Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2KUBv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:51:26 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58873 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab2KUBvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:51:25 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1211201104550.1692-100000@iolanthe.rowland.org>
References: <CAFCUKTS=SHoD4jpJe0_H6tsKcw-C9bAQP=VhXx+Lp8WZ4Xj6cA@mail.gmail.com>
	<Pine.LNX.4.44L0.1211201104550.1692-100000@iolanthe.rowland.org>
Date: Wed, 21 Nov 2012 09:51:24 +0800
Message-ID: <CAFCUKTS2NO4gptEqSjpZznXLtpj6qpjWhq96WonhcZBE8A-VYg@mail.gmail.com>
Subject: Re: [RFC] usb: add 'usb_get_intf()' call into the probe methods of
 drivers for usb interfaces.
From: harvey yang <harvey.huawei.yang@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your comments :)

Harvey


On Wed, Nov 21, 2012 at 12:09 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 19 Nov 2012, harvey yang wrote:
>
>> Hi, all
>> I checked many usb drivers in the mainline kernel which do not record
>> this reference in their probe methods. But according to the documents
>> about this function, we shoud record this reference in our probe
>> methods, just as the call to 'usb_get_dev()' to reference a usb
>> device. Are these usb drivers right or we need to fix them?
>
> The drivers are right; they do not need to be fixed.  The reason is
> because the drivers will be unbound automatically when the device or
> interface is unregistered.
>
> The only reason for a driver to take a reference would be if it wanted
> to continue using the device after it was unbound.  But drivers aren't
> supposed to do that.
>
> Alan Stern
>
