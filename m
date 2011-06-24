Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab1FXRGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 13:06:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:9240 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab1FXRGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 13:06:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=atQA1XTYFV/ZfhD5fvq6dGFeA3POdqniO9558Tz8gjzY0LkUdbadsaCOWxhBjmFF/z
         DIzYrI+aERXau2v3lPEw==
Date: Fri, 24 Jun 2011 10:06:22 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, Greg KH <gregkh@suse.de>,
        Sergiu Iordache <sergiu@chromium.org>, Valdis.Kletnieks@vt.edu,
        Andrew Morton <akpm@linux-foundation.org>,
        Samo Pogacnik <samo_pogacnik@t-2.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char drivers: Ram oops kernel configuration parameters
Message-ID: <20110624170621.GK13916@google.com>
References: <1308854160-16022-1-git-send-email-sergiu@chromium.org>
 <62229.1308859172@turing-police.cc.vt.edu>
 <BANLkTiko9PvSDHEnbjCAvcAReLytWwg7qSoZGv778xuj3tqW=g@mail.gmail.com>
 <20110623213315.GB4347@suse.de>
 <BANLkTin_ioBy-C15c6GkA4eirCAVEN-PHvuV3gOq0Ls3n5YTBw@mail.gmail.com>
 <BANLkTi=avK-_SWwS938=oPuKRMq_5Ai3bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=avK-_SWwS938=oPuKRMq_5Ai3bw@mail.gmail.com>
X-Operating-System: Linux/2.6.32-gg426-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco Stornelli (marco.stornelli@gmail.com) wrote:
> 2011/6/24 Mandeep Singh Baines <msb@chromium.org>:
> > On Thu, Jun 23, 2011 at 2:33 PM, Greg KH <gregkh@suse.de> wrote:
> >> On Thu, Jun 23, 2011 at 01:43:49PM -0700, Sergiu Iordache wrote:
> >>> On Thu, Jun 23, 2011 at 12:59 PM, <Valdis.Kletnieks@vt.edu> wrote:
> >>> > On Thu, 23 Jun 2011 11:36:00 PDT, Sergiu Iordache said:
> >>> > > Ramoops currently has module parameters for setting the configuration
> >>> > > variables (ram start, ram size and dump oopses). This makes it difficult to
> >>> > > configure when the module is compiled as a builtin.
> >>> >
> >>> > Can't you add 'ramoops.ram_start=128M ramoops.ram_size=64M' or similar
> >>> > to your kernel cmdline?
> >>>
> >>> You can but the problem is that when you're using the module as a
> >>> builtin managing the command line is harder than managing Kconfig
> >>> files. Instead of having different platform dependent config files
> >>> (which already exist in most of the cases) under source control you
> >>> would have to have different scripts which run the kernel with
> >>> different parameters.
> >>
> >> Then why not make the sysfs files writable?
> >>
> >
> > We do use sysctl and sysfs for most of our tuning stuff.
> >
> > But in this case, you wouldn't be able to write the sysfs file until
> > late in boot
> > so an early crashed would be lost.
> >
> > Our command-line is pretty generic across targets. Even across archs.
> >
> 
> Maybe using platform data? With archs with device tree support can be easy.
> 

FDT is a good idea. Thanks.

I guess for x86, we could add a file to drivers/platform/x86 to register
a device.

> Marco
