Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1FXKt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 06:49:27 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38650 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1FXKtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 06:49:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Cgd9LXR0TWUwyYi1uhrkw4oBJw+dUn8MsxIGyWqS+RptvBdWNRErchRcN2qgADu2Mh
         yYqM7wNa9DyDxK7FcsHrwZD+BPOolXCnHLWBwQ1sROyxubP5+c/2Bw/Fpx7hAoZW6sps
         wtOFpctZRf2bnYghS4Ug7VH58Nz/7I20VY+1s=
MIME-Version: 1.0
In-Reply-To: <BANLkTin_ioBy-C15c6GkA4eirCAVEN-PHvuV3gOq0Ls3n5YTBw@mail.gmail.com>
References: <1308854160-16022-1-git-send-email-sergiu@chromium.org>
	<62229.1308859172@turing-police.cc.vt.edu>
	<BANLkTiko9PvSDHEnbjCAvcAReLytWwg7qSoZGv778xuj3tqW=g@mail.gmail.com>
	<20110623213315.GB4347@suse.de>
	<BANLkTin_ioBy-C15c6GkA4eirCAVEN-PHvuV3gOq0Ls3n5YTBw@mail.gmail.com>
Date: Fri, 24 Jun 2011 12:49:24 +0200
Message-ID: <BANLkTi=avK-_SWwS938=oPuKRMq_5Ai3bw@mail.gmail.com>
Subject: Re: [PATCH] char drivers: Ram oops kernel configuration parameters
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Greg KH <gregkh@suse.de>, Sergiu Iordache <sergiu@chromium.org>,
        Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
        Samo Pogacnik <samo_pogacnik@t-2.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/24 Mandeep Singh Baines <msb@chromium.org>:
> On Thu, Jun 23, 2011 at 2:33 PM, Greg KH <gregkh@suse.de> wrote:
>> On Thu, Jun 23, 2011 at 01:43:49PM -0700, Sergiu Iordache wrote:
>>> On Thu, Jun 23, 2011 at 12:59 PM, <Valdis.Kletnieks@vt.edu> wrote:
>>> > On Thu, 23 Jun 2011 11:36:00 PDT, Sergiu Iordache said:
>>> > > Ramoops currently has module parameters for setting the configuration
>>> > > variables (ram start, ram size and dump oopses). This makes it difficult to
>>> > > configure when the module is compiled as a builtin.
>>> >
>>> > Can't you add 'ramoops.ram_start=128M ramoops.ram_size=64M' or similar
>>> > to your kernel cmdline?
>>>
>>> You can but the problem is that when you're using the module as a
>>> builtin managing the command line is harder than managing Kconfig
>>> files. Instead of having different platform dependent config files
>>> (which already exist in most of the cases) under source control you
>>> would have to have different scripts which run the kernel with
>>> different parameters.
>>
>> Then why not make the sysfs files writable?
>>
>
> We do use sysctl and sysfs for most of our tuning stuff.
>
> But in this case, you wouldn't be able to write the sysfs file until
> late in boot
> so an early crashed would be lost.
>
> Our command-line is pretty generic across targets. Even across archs.
>

Maybe using platform data? With archs with device tree support can be easy.

Marco
