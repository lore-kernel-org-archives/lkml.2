Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab1KOVO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:14:29 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9848 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab1KOVO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:14:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 15 Nov 2011 13:14:25 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Denis Kuzmenko <linux@solonet.org.ua>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Nov 2011 13:14:25 -0800
Subject: RE: [PATCH] gpio/gpio-sysfs: Try to export busy GPIO line leads to
 wrong GPIO line exporting
Thread-Topic: [PATCH] gpio/gpio-sysfs: Try to export busy GPIO line leads to
 wrong GPIO line exporting
Thread-Index: Acyj1FMHQ86TUvN7TBOdiZhItz2oGAABrCVQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740805E7F@HQMAIL01.nvidia.com>
References: <4EBF1DD1.8090600@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF1740805B5B@HQMAIL01.nvidia.com>
 <4EC1A0BE.3000901@solonet.org.ua> <4EC2CA45.7070605@solonet.org.ua>
In-Reply-To: <4EC2CA45.7070605@solonet.org.ua>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Kuzmenko wrote at Tuesday, November 15, 2011 1:24 PM:
> On 11/15/2011 01:14 AM, Denis Kuzmenko wrote:
> > On 11/14/2011 10:45 PM, Stephen Warren wrote:
> >> Denis Kuzmenko wrote at Saturday, November 12, 2011 6:31 PM:
> >
> > Looks like userspace doesn't retries write. Here is trace:
> >
> > open("/sys/class/gpio/export", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
> > ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbef76c64) = -1 ENOTTY (Inappropriate ioctl for device)
> > brk(0x30e000)                           = 0x30e000
> > write(3, "37\n", 3)                     = -1 EBUSY (Device or resource busy)
> > close(3)                                = 0
> > exit(0)                                 = ?
> >
> > this was made by simple self-written program:
> > 	fopen("/sys/class/gpio/export", "w"); fprintf(fp, "37\n");
> 
> That was userspace - problem in not reproducible with a code above.
> The only way I know to reproduce is:
> echo 37 > /sys/class/gpio/export
> 
> Traces are generated:
> 
...
> stat("/lib/ld-uClibc.so.0", {st_mode=S_IFREG|0755, st_size=21200, ...}) = 0

Hmmm. I'd be tempted to look at the stdio implementation in uClibc first, or
possibly the shell you're running.

> write(1, "37\n", 3)                     = -1 EBUSY (Device or resource busy)
> write(1, "3", 1)                        = -1 EBUSY (Device or resource busy)
> write(1, "3", 1)                        = -1 EBUSY (Device or resource busy)

My ARM system running some random build of Debian Wheezy doesn't repro
that; I see the first write() fail, and then no more writes are attempted.

For the record, I tried GPIO 570 (an invalid value), and got back
-EINVAL, and GPIO 57 (a valid but already requested GPIO) and got back
-EBUSY. Both had the same behavior.

-- 
nvpublic

