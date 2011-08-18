Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab1HRTNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:13:10 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:52153 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab1HRTNE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:13:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110818183712.GC18881@suse.de>
References: <CA+O4pCKfWLP+ohfUVi811CRbmrb2FyoMwkmxxGJ1TF2kKtGDEA@mail.gmail.com>
	<20110818183712.GC18881@suse.de>
Date: Thu, 18 Aug 2011 21:13:04 +0200
Message-ID: <CA+O4pCJn8bEafT1Z83gGY00-y705nxN6+tcr3pe6HLDW0s6sUw@mail.gmail.com>
Subject: Re: [PATCH] Increase usbfs bulk buffer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 8:37 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Aug 17, 2011 at 07:07:01PM +0200, Markus Rechberger wrote:
>> Hi,
>>
>> this patch increases the maximum buffersize for bulk transfers, our
>> devices support at least up to 46k bytes for bulk transfers.
>> This patch allows us to lower the iterations between kernel and
>> userspace and lower the system pressure.
>
> But as Oliver pointed out, this increases the memory pressure.  I'm
> curious why you say there is "system pressure" with the current buffer
> size.  What is the problems here, you are just passing the same logic
> issues down to the kernel, that you should be handling in userspace if
> you want to use usbfs.
>

userspace applications are not realtime applications, the bigger the buffer
the less buffers will be required.
As noted this is just 1/4th the buffersize we are already using with
Isochronous.
Back then with small isochronous buffers even moving the mozilla GUI
window could
cause incomplete data (and I'm talking about 170mbit per second
transfers here), with increased buffers this issue is gone (and it's
gone
since I submitted a similar patch for isochronous ~1-2 years ago).
In case of bulk allocations can go down for 2/3 of the current
pressure, of course it goes up on another side but that side has a
better performance.

>> Signed-off-by: Markus Rechberger <mrechberger@gmail.com>
>
> Also note that this is a user/kernel API that you are changing, are you
> _sure_ you didn't just break some user code with this change that was
> assuming that the buffer size was 16Kb, as it's been that way for the
> past 10 years?
>

just the check about the maximum allowed buffer size will be
increased, nothing else.
Existing applications will still go for 16k.

BR,
Markus


> thanks,
>
> greg k-h
>
