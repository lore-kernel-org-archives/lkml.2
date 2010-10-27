Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab0J0B2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 21:28:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38480 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab0J0B2j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 21:28:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:in-reply-to:mime-version:content-transfer-encoding
         :content-type:message-id:cc:x-mailer:from:subject:date:to;
        b=tlqgSGjH46FBpQGIR5MqwgpEC61NieYE1aZXwCJN5F18u7Cj19S2Ia3y3ySsAy009T
         OExC0yPR+XCzYZSmICU9b/coKdrPT17bUqzDX+Srg+8jP3HfUmGzFvYG+fh81tEcvNXo
         zx0+WMvYw326slUSHEn2TcNdUs3jF4HKXQRCs=
References: <cover.1288059486.git.joe@perches.com> <20101026155028.GA13097@core.coreip.homeip.net> <1288135531.4145.59.camel@Joe-Laptop> <201010261740.13566.dmitry.torokhov@gmail.com> <1288140416.4145.76.camel@Joe-Laptop> <BFA186FD-32F7-4E1A-9193-CA1575248B73@gmail.com> <1288141825.4145.83.camel@Joe-Laptop>
In-Reply-To: <1288141825.4145.83.camel@Joe-Laptop>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <4E27039C-DE6B-4C90-ADC5-68D3B30F75E6@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8B117)
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 06/10] drivers/input/serio/i8042: Use pr_<level>, pr_fmt. Fix dbg and __FILE__ use
Date: Tue, 26 Oct 2010 18:28:19 -0700
To: Joe Perches <joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 26, 2010, at 6:10 PM, Joe Perches <joe@perches.com> wrote:

> On Tue, 2010-10-26 at 18:00 -0700, Dmitry Torokhov wrote:
>> On Oct 26, 2010, at 5:46 PM, Joe Perches <joe@perches.com> wrote:
>>> On Tue, 2010-10-26 at 17:40 -0700, Dmitry Torokhov wrote:
>>>>> Mind if I move the time to the front like this?
>>>>> +#define dbg(format, arg...)                                            \
>>>>> +do {                                    \
>>>>> +    if (i8042_debug)                        \
>>>>> +        printk(KERN_DEBUG KBUILD_MODNAME ": [%d]" format),    \
>>>>> +                      (int)(jiffies - i8042_start_time), ##arg);    \
>>>>> +} while (0)
>>>> Another option would be to leave '\n' in dbg() and leave most of the
>>>> callers as is.
>>> That's really error prone though.
>> In what way?
> 
> $ grep -w dbg drivers/input/serio/i8042.c | cat -n
>     1            dbg("%02x <- i8042 (flush, %s)", data,
>     2        dbg("%02x -> i8042 (command)", command & 0xff);
>     3            dbg("%02x -> i8042 (parameter)", param[i]);
>     4                dbg("     -- i8042 (timeout)");
>     5                dbg("     -- i8042 (auxerr)");
>     6            dbg("%02x <- i8042 (return)", param[i]);
>     7            dbg("%02x -> i8042 (kbd-data)", c);
>     8                dbg("Extra keyboard ACK - filtered out\n");
>     9            dbg("Filtered out by platform filter\n");
>    10            if (irq) dbg("Interrupt %d, without any data", irq);
>    11                dbg("MUX error, status is %02x, data is %02x", str, data);
>    12        dbg("%02x <- i8042 (interrupt, %d, %d%s%s)",
>    13            dbg("%02x <- i8042 (aux_test_irq, %s)",
>    14            dbg("     -- i8042 (aux irq test timeout)");
>    15        dbg("%02x -> i8042 (panic blink)", 0xed);
>    16        dbg("%02x -> i8042 (panic blink)", led);
> 
> I think 2 defects in 16 uses is a pretty high error rate.

But how not adding /n is it much better than having it if some later change will forget to add it to the message?

-- 
Dmitry


