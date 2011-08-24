Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab1HXWSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:18:36 -0400
Received: from mail.microway.com ([206.173.81.22]:58358 "EHLO microway.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750770Ab1HXWSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:18:34 -0400
Message-ID: <cf5a31c38191654364bd281df6cb81e0.squirrel@www.microway.com>
In-Reply-To: <4E547B0F.6000001@intel.com>
References: <201108171751.51648.rick@microway.com>
    <8338f9871d1f52f9376a1eca319a7866.squirrel@www.microway.com>
    <201108222047.11086.rjw@sisk.pl> <201108221651.35654.rick@microway.com>
    <20110823171432.GA10794@redhat.com>
    <faf1d1211a8d409b39119e44727b3c83.squirrel@www.microway.com>
    <4E547B0F.6000001@intel.com>
Date: Wed, 24 Aug 2011 18:18:33 -0400
Subject: Re: kernel oops and panic in acpi_atomic_read under 2.6.39.3.   call
 trace included
From: rick@microway.com
To: "Huang Ying" <ying.huang@intel.com>
Cc: "Don Zickus" <dzickus@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Richard Houghton" <rhoughton@microway.com>,
        "ACPI Devel Mailing List" <linux-acpi@vger.kernel.org>,
        "Len Brown" <lenb@kernel.org>, "Matthew Garrett" <mjg59@srcf.ucam.org>
User-Agent: SquirrelMail/1.4.21
X-Priority: 3 (Normal)
Importance: Normal
X-Sanitizer: Advosys mail filter
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

The original system needs to ship to our customer ASAP.  Disabling ghes is
sufficient for the time being for that.  As such, I have set up an
identical system as a temporary master for another cluster to continue
this testing.

I have applied your patch.  Here is the output of dmesg | grep GHES so far:


[    9.272198] GHES: gar mapped: 0, 0xbf7b5ff0
[    9.280782] GHES: gar mapped: 0, 0xbf7b6200
[    9.285102] [Firmware Warn]: GHES: Poll interval is 0 for generic
hardware error source: 1, disabled.

I have the serial console activated and stress tests started back up. 
I'll reply with the output once I get another panic.

Thanks!
Rick

> Hi, Rick,
>
> It appears that panic occurs in acpi_atomic_read.  I think the most
> likely cause is that the acpi_generic_address is not pre-mapped.  Can
> you try the patch attached?
>
> It will print registers mapped and accessed.  To use it, run the
> following command line before workload.
>
> dmesg | grep GHES
>
> Then try to find something like
>
> GHES: gar accessed: x, xxxx
>
> in kernel log when panic occurs.
>
> Best Regards,
> Huang Ying
>
>


