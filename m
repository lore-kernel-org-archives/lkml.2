Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0IBL4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 07:56:55 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:37524 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508Ab0IBL4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 07:56:53 -0400
Message-ID: <e875e8d2d6b6000fcb31da07f393618f3466233c@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
In-Reply-To: <Pine.LNX.4.44L0.1009011334160.1617-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1009011334160.1617-100000@iolanthe.rowland.org>
Date: Thu, 2 Sep 2010 12:56:49 +0100
Subject: Re: [PATCH] USB: output an error message when the pipe type 
 doesn't match the endpoint type
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Greg KH" <greg@kroah.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "USB list" <linux-usb@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, September 1, 2010 18:49, Alan Stern wrote:
> On Wed, 1 Sep 2010, Simon Arlott wrote:
>> > This is okay with me.  If you're serious about not changing the
>> > behavior merely because debugging is enabled, you could move this test
>> > out of the debug-only region and possibly change the dev_err to
>> > dev_dbg.  However doing so might break some devices that are currently
>> > working.
>>
>> I'd expect that to break potentially many devices, although only cxacru
>> stopped working for me. The USB API isn't really suitable for adding
>> this type of check because it allows the drivers to get away with too
>> much already.
>
> Unlike device hardware, drivers can always be changed.  If adding a
> check will help spot errors, it's probably worthwhile.

Yes, however the information about the device endpoint types hasn't been
required in the past for the driver to work. The only way to check is to
have the hardware available so the error may only show up after a full
release of the kernel and break drivers that used to work. It could be
enabled for all -rc kernels...

>> usb_clear_halt() takes a pipe when it really wants the endpoint, the
>> pipe type is ignored.
>
> What's wrong with that?  Besides, in the end we shouldn't be using
> pipes at all; we should always use pointers to struct
> usb_host_endpoint.

If a driver was trying to conform to the "don't use the wrong pipe type
with an endpoint" rule then it may have to check it was using the
correct pipe when calling usb_clear_halt(), although this is only a
problem with drivers where the devices sometimes have interrupt instead
of bulk endpoints.

Looking at usb_clear_halt(), it doesn't use the direction either... but
drivers can call it in both directions. Several drivers already do this.

-- 
Simon Arlott
