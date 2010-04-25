Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0DYUKD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 16:10:03 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49400 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab0DYUKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 16:10:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VtYA1zaljRV1xtyZF+SGfpO7fCnGwsON9H9pCNRjw3ySWxRGf/7w/ONwoJUiJXA0VR
         qG649tdUBL+yKtmxvYsRO5jxG6uSD1iasNq6E13KwQ8l1r1JMkOtshrJ0tdeGz8Yt15t
         GefKCOzdYnCdT0dRYRgKfvBak6Ss6+z0hrq7w=
MIME-Version: 1.0
In-Reply-To: <20100425193658.GA24039@kroah.com>
References: <k2h1ba2fa241004190520z5f048287v6f84e9117b04c803@mail.gmail.com>
	 <20100419145934.GA10893@kroah.com>
	 <t2w1ba2fa241004211522le49fc938m341553b0f2b89031@mail.gmail.com>
	 <20100425163711.GA20196@kroah.com>
	 <o2n1ba2fa241004251222x6ab49726p9757fd8be4952bee@mail.gmail.com>
	 <20100425193658.GA24039@kroah.com>
Date: Sun, 25 Apr 2010 23:09:58 +0300
Message-ID: <m2g1ba2fa241004251309oa5592255lb4e4b96ea07dd12a@mail.gmail.com>
Subject: Re: request_firmware API exhaust memory
From: Tomas Winkler <tomasw@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Kay Sievers <kay.sievers@vrfy.org>,
       David Woodhouse <dwmw2@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Emmanuel Grumbach <egrumbach@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 10:36 PM, Greg KH <greg@kroah.com> wrote:
> On Sun, Apr 25, 2010 at 10:22:54PM +0300, Tomas Winkler wrote:
>> On Sun, Apr 25, 2010 at 7:37 PM, Greg KH <greg@kroah.com> wrote:
>> > On Thu, Apr 22, 2010 at 01:22:51AM +0300, Tomas Winkler wrote:
>> >> On Mon, Apr 19, 2010 at 5:59 PM, Greg KH <greg@kroah.com> wrote:
>> >> > On Mon, Apr 19, 2010 at 03:20:34PM +0300, Tomas Winkler wrote:
>> >> >> Lately we've been developing a device that rather more extensively
>> >> >> used request_firmware API in load and also using pm_notifiers to load
>> >> >> firmware.
>> >> >
>> >> > Do you have a pointer to your driver source anywhere that shows how you
>> >> > are trying to use the firmware api in this manner?
>> >>
>> >> I've attached a very simple ??test driver I'm using. ??Just wanted to
>> >> eliminate anything else.
>> >> Bellow is a little script that loads and releases the firmware. My
>> >> previous observation was wrong.
>> >> The free memory gradually decreases regardless of number or dangling
>> >> udevd forks, which are eventually collected if the sleep period is
>> >> long enough ~10s.
>> >
>> > That sounds normal for the free memory. ??Kay, that's also to be expected
>> > for the udevd forks as well, right?
>>
>> Sorry maybe I was not clear what I mean that the memory will be
>> eventually exhausted and system will crash
>> Is this normal?
>
> Ah, no, that's not normal.  Have you run kmemleak on your module (or
> test module) to verify that you are properly freeing up the memory?

yes, one of my college has run the kmemleak but didn't bring much
evidence.  I've also looked into slubinfo as suggested by Johannes
but don't see anything suspicions either but this is expected as
everything is allocated through kmalloc and alloc_pages.
I may rerun the kmemleak by myself but this shows up on too many
setups and kernels with also full driver and also my simple test
driver.

>
>> Actually I less suspect now udevd as the same happens on android
>> platform where there is no udev
>
> Which is a sad thing for a whole other range of issues...

Said thing is that I don't see where the memory goes.... Anyhow I will
try to run valgrin on udev just to be sure.

I'll be glad If someone can run my simple driver I posted and confirm
that sees the same problem

Thanks
Tomas
