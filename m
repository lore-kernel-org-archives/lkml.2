Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab2IUVck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 17:32:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64861 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab2IUVci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 17:32:38 -0400
MIME-Version: 1.0
In-Reply-To: <2737921.JXTsrgJ0N6@dtor-d630.eng.vmware.com>
References: <1348163523-2062-1-git-send-email-dh.herrmann@googlemail.com>
	<CANq1E4Q-35oF11Dz6mbNvNYpWYSfOgCXW_E4ZwJ2neZB8p_64w@mail.gmail.com>
	<CANq1E4Rcj0UsgQr=0sohXn8rXpY92PMnHAYwXNpsPPFULHQsrw@mail.gmail.com>
	<2737921.JXTsrgJ0N6@dtor-d630.eng.vmware.com>
Date: Fri, 21 Sep 2012 23:32:37 +0200
Message-ID: <CANq1E4RJk5f0nVWeWvGrGVKzCrK1A3Gue3Z_3fkb91CX_LNj4g@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] input: Dynamic Minor Numbers
From: David Herrmann <dh.herrmann@googlemail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry

On Fri, Sep 21, 2012 at 10:51 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Friday, September 21, 2012 09:18:00 PM David Herrmann wrote:
>> Hi Dmitry
>>
>> On Fri, Sep 21, 2012 at 11:22 AM, David Herrmann
>>
>> <dh.herrmann@googlemail.com> wrote:
>> > Hi Dmitry
>> >
>> > On Fri, Sep 21, 2012 at 10:07 AM, Dmitry Torokhov
>> >
>> > <dmitry.torokhov@gmail.com> wrote:
>> >> Thank you very much for working on this, unfortunately your patch extends
>> >> the existing infrastructure handling of character devices in input core,
>> >> which is quite rigid and sub-optimal.
>> >>
>> >> For a while now I wanted to stop input core from pre-creating character
>> >> devices and multiplexing file operations and instead push more chardev
>> >> handling tasks into individual input handlers and make they more
>> >> independent from input core. So while I won't be taking your patch as is
>> >> it was a great motivator to finally do something about current
>> >> limitation and I would appreciate if you could take a look at the patch
>> >> below and see if you have any issues with it.
>> >
>> > I didn't know why we did that, anyway. But I tried to keep that logic,
>> > even though it is really weird. So I am quite glad that you fixed it.
>>
>> Sorry, compiling a kernel takes 44m here so I haven't had time earlier
>> this day. But I just recompiled with your patch and it works like a
>> charm. I have attached output of "ls -la /dev/input" with 900 uinput
>> devices. Performance does suck but that is definitely another issue.
>
> Could you elaborate a bit on this?

It takes like 2s to create 100 devices. Ok, that's about 500 syscalls.
But still, 2s seemed pretty much to me. But that's probably related to
uinput. 1000 devices take like 10s here.
Also the xserver crashes when connecting more than 40 or 50 devices.
It does print "too many devices; ignoring" but there seems to be some
error-path bug.
I haven't noticed any runtime kernel bugs or runtime
performance-drops, though. So as I said, there are some issues, that
need to be solved, but they are not related to input-core. (Also,
creating 1000 uinput devices doesn't seem like a use-case that we
should try to optimize).

Regards
David
