Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab1FWWHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:07:20 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4908 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab1FWWHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cMnnUEGGITidDEK2f87iE1SE5aUz8051BA2layk0Z/rcyXQnfqI5uVm9WlL44mK6HC
         5ZEQphEjVYT/92h1S3GQ==
MIME-Version: 1.0
In-Reply-To: <20110623213315.GB4347@suse.de>
References: <1308854160-16022-1-git-send-email-sergiu@chromium.org>
	<62229.1308859172@turing-police.cc.vt.edu>
	<BANLkTiko9PvSDHEnbjCAvcAReLytWwg7qSoZGv778xuj3tqW=g@mail.gmail.com>
	<20110623213315.GB4347@suse.de>
Date: Thu, 23 Jun 2011 15:07:12 -0700
X-Google-Sender-Auth: 5WXO1ghS-QgBTivwrwCYXr8Rmhc
Message-ID: <BANLkTin_ioBy-C15c6GkA4eirCAVEN-PHvuV3gOq0Ls3n5YTBw@mail.gmail.com>
Subject: Re: [PATCH] char drivers: Ram oops kernel configuration parameters
From: Mandeep Singh Baines <msb@chromium.org>
To: Greg KH <gregkh@suse.de>
Cc: Sergiu Iordache <sergiu@chromium.org>, Valdis.Kletnieks@vt.edu,
        Andrew Morton <akpm@linux-foundation.org>,
        Samo Pogacnik <samo_pogacnik@t-2.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 2:33 PM, Greg KH <gregkh@suse.de> wrote:
> On Thu, Jun 23, 2011 at 01:43:49PM -0700, Sergiu Iordache wrote:
>> On Thu, Jun 23, 2011 at 12:59 PM, <Valdis.Kletnieks@vt.edu> wrote:
>> > On Thu, 23 Jun 2011 11:36:00 PDT, Sergiu Iordache said:
>> > > Ramoops currently has module parameters for setting the configuration
>> > > variables (ram start, ram size and dump oopses). This makes it difficult to
>> > > configure when the module is compiled as a builtin.
>> >
>> > Can't you add 'ramoops.ram_start=128M ramoops.ram_size=64M' or similar
>> > to your kernel cmdline?
>>
>> You can but the problem is that when you're using the module as a
>> builtin managing the command line is harder than managing Kconfig
>> files. Instead of having different platform dependent config files
>> (which already exist in most of the cases) under source control you
>> would have to have different scripts which run the kernel with
>> different parameters.
>
> Then why not make the sysfs files writable?
>

We do use sysctl and sysfs for most of our tuning stuff.

But in this case, you wouldn't be able to write the sysfs file until
late in boot
so an early crashed would be lost.

Our command-line is pretty generic across targets. Even across archs.

> Stuff like this should not be picked from the configuration build if at
> all possible.  The fact that you feel changing the Kconfig is easier
> than your boot command line shows a problem in your overall system
> configuration.
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
