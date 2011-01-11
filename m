Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1AKONO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:13:14 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36062 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab1AKONL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:13:11 -0500
Date: Tue, 11 Jan 2011 15:13:59 +0100
From: Borislav Petkov <bp@amd64.org>
To: "James C. Georgas" <james.georgas@yahoo.ca>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: can't resume from ACPI S3 with TICK_ONESHOT
Message-ID: <20110111141359.GD17619@aftab>
References: <1294191939.3889.49.camel@Tachyon>
 <20110105120959.GB4927@kryptos.osrc.amd.com>
 <1294242385.3650.38.camel@Tachyon>
 <20110107111658.GE16507@aftab>
 <1294420550.17472.1.camel@Tachyon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294420550.17472.1.camel@Tachyon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 12:15:50PM -0500, James C. Georgas wrote:
> On Fri, 2011-01-07 at 12:16 +0100, Borislav Petkov wrote:
> > On Wed, Jan 05, 2011 at 10:46:25AM -0500, James C. Georgas wrote:
> > > Let me know if you need more.
> > 
> > Yeah, what does
> > 
> > xxd /sys/firmware/acpi/tables/HPET
> > 
> > say?
> > 
> 
> Tachyon james # xxd /sys/firmware/acpi/tables/HPET
> 0000000: 4850 4554 3800 0000 012a 5054 4c54 4420  HPET8....*PTLTD 
> 0000010: 4850 4554 5442 4c20 0000 0406 204c 5450  HPETTBL .... LTP
> 0000020: 0100 0000 1082 5343 0000 0000 0000 d0fe  ......SC........
> 0000030: 0000 0000 0080 0000                      ........
> Tachyon james # 

Ok, I don't see anything irregular here. Can you try booting the
original tickless (NO_HZ) configuration without the "nohpet" boot option
and wait >= 5 mins after resume to see whether your machine comes to
life afterall. The 5min means we want to wait until the 32-bit HPET
counter overflows to see whether the timer gets programmed with an event
in the past right after resume.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
