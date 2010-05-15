Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab0EOB0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 21:26:22 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:61031 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab0EOB0S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 21:26:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=Njn7SArSYZATM+wGU1txynqAa+j8ku1aI9RCecuzSp9iEBymPuLwmaMdj+/bmriivd
         wdviIUGjAvYDHH6l6uN8nPv3p65I2k22ZUjF+NVvKCElmT7EAK1Pe0IkgcC2cjzMLqZT
         qYskjbyl4JjIM85R0kHG0XSWBPAml6MSYh2JI=
References: <201005141538.43416.br1@einfach.org> <4BED6F19.3040608@gmail.com> <20100514165325.GA28198@tux> <4BED8765.8040307@gmail.com> <AANLkTiky103uOz38yZPlLypEQ8DnkdCk1X3zPl9014Yi@mail.gmail.com> <67773379-350A-42D4-BEB5-DAC7D8277615@gmail.com> <20100514201339.GB28198@tux> <4638F7CF-1E00-411F-A086-BA30809E00BD@gmail.com> <20100514205253.GC28198@tux> <B796B1C7-D7CC-457A-9C86-7C70EA9451CF@gmail.com> <20100515005201.GH28198@tux>
Message-Id: <99B6B8BB-F155-4B15-95AF-C8DF3F5B4382@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <20100515005201.GH28198@tux>
Content-Type: text/plain;
	charset=utf-8;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 8BIT
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
Date: Fri, 14 May 2010 18:26:33 -0700
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Bruno Randolf <br1@einfach.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Miles Lane <miles.lane@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Justin P. Mattock



On May 14, 2010, at 5:52 PM, "Luis R. Rodriguez"  
<lrodriguez@atheros.com> wrote:

> On Fri, May 14, 2010 at 03:32:48PM -0700, Justin P. Mattock wrote:
>> ATH9K: cachelsz 256 rxbufsize 3904
>
> OK I see nothing odd with these values, and I do not see how
> these values can make ath_rxbuf_alloc() barf. I'd like to
> reproduce this myself at least once, I left iperf running over
> night with no rants from SLAB. I should note this should be
> reproducible with RX only if it is ath_rxbuf_alloc() to blame
> but without a concrete reproducible instructions it is hard
> to guess what to do and if this can only come up during RX.
>
> Can you describe a little more when you have seen this? What
> were you doing exactly, for how long? When was the last time
> you saw this, what were you doing then?
>
>  Luis

This is hard to reproduce(reason for looking a kmemchek).

As for what I remember, walked into the las Vegas convention cntr 
(Hilton),
Found the Internet hub, scanned for networks, wicd said it was  
connected, opened firefox to see the prices, ended up seeing a blank  
page(at this point didn't look at dmesg(could have already happened)),  
then switched to another network(did this a few times),
Eventually opened firefox(saw the prices, said fuc*k this), then  
started to read up on i8042.c(cause Linus was pull requesting and I  
wanted to find out what was going on in that area), then
Checked dmesg, and voilà there the bug is.

After this rebooted, was hoping this was reproducable for a bisect,  
but realized it's not the reproducable..


Justin P. Mattock