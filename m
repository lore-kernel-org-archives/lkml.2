Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab1DKVgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 17:36:42 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54622 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab1DKVgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 17:36:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SOFKdTSKJY/hvOv8IztjXUZqpXAjZ+RZzLnK40e+zHEdxLPSeed5+UU2Iw8IqaFjZH
         ja/WKCsq46i1dFdjfcSP3JeBfSDKM0bm8LnfjBVOVrUv3laFwMnOB/7ItVvv3/EfjOsy
         e4L+35m5tKZ+mROm/D5UzbW/p2jblwxc8oLx0=
MIME-Version: 1.0
In-Reply-To: <20110411212513.GA17809@kroah.com>
References: <1302557114-7880-1-git-send-email-zajec5@gmail.com>
	<20110411210631.GA28559@kroah.com>
	<BANLkTim155YxMUVJ=pmVs-rNhkovGPG6OQ@mail.gmail.com>
	<20110411212513.GA17809@kroah.com>
Date: Mon, 11 Apr 2011 23:36:39 +0200
Message-ID: <BANLkTingqXAWTeOhcL6ER0UJfEdQF5Bo2A@mail.gmail.com>
Subject: Re: [RFC][PATCH V3] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        Andy Botting <andy@andybotting.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/11 Greg KH <greg@kroah.com>:
> On Mon, Apr 11, 2011 at 11:19:13PM +0200, Rafał Miłecki wrote:
>> 2011/4/11 Greg KH <greg@kroah.com>:
>> > On Mon, Apr 11, 2011 at 11:25:14PM +0200, Rafał Miłecki wrote:
>> >> +static void axi_release_core_dev(struct device *dev)
>> >> +{
>> >> +     /* Silent lack-of-release warning */
>> >> +}
>> >
>> > Ok, WTF!!!!
>>
>> Thank you for your kindly words. It's much more enjoyable to work on
>> kernel that way. I definitely made that on purpose.
>
> I can't tell if you are kidding or not.

That was 100% irony. I swear I don't enjoy publishing bad code and
getting such a comment.


> Please read the documentation for how to do this properly.  I find it
> really hard to believe that you wrote that comment instead of putting in
> the 2 lines of code required for this function.
>
> Especially as-it-is, your code does not work properly and leaks memory
> badly.  Why would you do that on purpose?

I tried to read some documentation about this.

1) driver-mode/device.txt says only that:
> Callback to free the device after all references have
> gone away. This should be set by the allocator of the
> device (i.e. the bus driver that discovered the device).
I *really* do not know how my driver should "free" core on AXI bus.

2) LDD3 says:
> The method is called when the last reference to the device is removed; it is called
> from the embedded kobject’s release method. All device structures registered with
> the core must have a release method, or the kernel prints out scary complaints.
Well, I do not register any structs for AXI core.

3) Example code from LDD3:
static void ldd_bus_release(struct device *dev)
{
printk(KERN_DEBUG "lddbus release\n");
}
Yeah, that's what I did...

4) SSB in it's ssb_release_dev just calls kfree on struct that was
allocated when registering drivers. *I do not* allocate such a struct,
so I believe I do exactly the same memory leak as SSB does.


Can you spend 2 more minues in addition to commenting my ideas and
help me with writing that 2 lines I missed? Where do I leak memory in
my driver? Which struct should I kfree?

-- 
Rafał
