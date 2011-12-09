Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab1LIEVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:21:13 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44384 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab1LIEVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:21:11 -0500
MIME-Version: 1.0
In-Reply-To: <20111209001145.GB9550@kroah.com>
References: <1323309517.979.8.camel@mop> <20111209001145.GB9550@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 9 Dec 2011 05:20:50 +0100
Message-ID: <CAPXgP12tds9gPKie+B6358XkhyP1K2fLFGw698-wwsuKx_bcew@mail.gmail.com>
Subject: Re: [PATCH-WIP] convert CPU sysdev class to a real subsytem (needed
 for CPU modaliases)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, trenn@suse.de,
        davej@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 9, 2011 at 01:11, Greg KH <greg@kroah.com> wrote:
> On Thu, Dec 08, 2011 at 02:58:37AM +0100, Kay Sievers wrote:

>> Greg, I guess we need a bit of your time, to make a plan and get the
>> remaining things sorted out. We are planning and fiddling for years
>> already here, and we should finally get the stuff out. :)
>
> I agree, I want this to get done finally.
>
>> Greg, I think with the subsys_interfaces we do not need the
>> 'multi-driver-binding' anymore, seems we can get away with the
>> interfaces only. Classes which need to convert to buses because the
>> class interface is not extensible can be easily converted now. The only
>> missing piece is the 'glue directory'. We should be able to unify
>> classes and buses internally with all that stuff.
>
> Ah, good, I was stalled on this because of the multi-driver-binding
> stuff.  If that's not needed, I'll gladly take any patches for this.

Yeah, I think we don't really need them. The 'interfaces' act as a
sort of 'lightweight driver'. We do that with the class_interfaces
already and I think that works well enough. At least the
sysdev_drivers I converted already, all fit 1:1 into the
subsys_interface.

> So, what do I need to do here?  Your patch looks good at first glance,
> the interface logic looks sane, is that all that we really need to do to
> the core?

Yeah, it seems to work out well. I converted all generic and the x86
code, and after removing drivers/base/sys.c and include/linux/sysdev.h
it looks like this:
   53 files changed, 1014 insertions(+), 1256 deletions(-)
Which could be a sign of doing the right thing.

I'll finish what I have now, then split out the driver-core changes
which we can possibly merge without affecting anything else. I should
get that ready next week.

Then we can check how to proceed with all the individual things to
convert over, and how to do the arch stuff (~70 files), which I have
no idea how to test ... but we've been there with the struct
class_device a few years back already, we'll find it out. :)

After the last user is gone, we can finally remove the sysdevs.

Kay
