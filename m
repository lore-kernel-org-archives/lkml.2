Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab1CKHmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 02:42:32 -0500
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.184]:11978
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865Ab1CKHma convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 02:42:30 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zz1432N98dN4015Lzz1202hzz8275eh8275bh8275dha1495iz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LHVUQ1-02-0TF-02
X-M-MSG: 
Date: Fri, 11 Mar 2011 08:41:56 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Wang Lei <f3d27b@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [BUG] Fans keep running, first found since v2.6.38-rc7
Message-ID: <20110311074156.GD13156@alberich.amd.com>
References: <4d774c85.20f98e0a.2695.73ed@mx.google.com>
 <201103092125.43950.rjw@sisk.pl>
 <4d780a2f.231a8f0a.3b01.ffffa228@mx.google.com>
 <201103100106.36678.rjw@sisk.pl>
 <4d796b47.20f98e0a.2695.fffff615@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4d796b47.20f98e0a.2695.fffff615@mx.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lei,

can you please provide information, which system you are using.  dmesg
(please use apic=debug kernel parameter), output of lspci -nnxxxx (as
root),

This reminds me on some HP laptop issues, see
https://bugzilla.kernel.org/show_bug.cgi?id=11715
https://bugzilla.kernel.org/show_bug.cgi?id=11516
The BIOSes on HP laptops somehow checked IO-APIC configuration
and set trip_points differently (for unknown reason).

But I need above debug info to sort this out.


Thanks,

Andreas


On Thu, Mar 10, 2011 at 07:04:51PM -0500, Wang Lei wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Thursday, March 10, 2011, Wang Lei wrote:
> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >> 
> >> > On Wednesday, March 09, 2011, Wang Lei wrote:
> >> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >> >> 
> >> >> >
> >> >> > There was only one commit in that area since 2.6.38-rc6, but it shouldn't
> >> >> > affect the functionality this way.
> >> >> >
> >> >> > Is yout thermal management controlled by ACPI?
> >> >> >
> >> >> > Rafael
> >> >> 
> >> >> Thanks for your reply!
> >> >> 
> >> >> How could I know that?
> >> >
> >> > What does "ls -l /sys/class/thermal/cooling_device0/device" say?
> >> >
> >> > Rafael
> >> 
> >> [~]$ ls -l /sys/class/thermal/cooling_device0/device
> >> lrwxrwxrwx 1 root root 0 Mar 10 07:13 /sys/class/thermal/cooling_device0/device -> ../../../LNXSYSTM:00/device:47/PNP0C0B:00
> >> [~]$
> >
> > That's ACPI.
> >
> > I don't know, however, which change might cause the problem to happen.
> >
> > Can you bisect the commits between 2.6.38-rc6 and -rc7 to find the one that
> > introduced the issue?
> >
> > Rafael
> 
> Thanks, Rafael.
> Bisect stopped at commit 7f74f8f28a2bd9db9404f7d364e2097a0c42cc12
> 
> --------------------
> [~/repository/kernel]$ git bisect good
> 7f74f8f28a2bd9db9404f7d364e2097a0c42cc12 is the first bad commit
> commit 7f74f8f28a2bd9db9404f7d364e2097a0c42cc12
> Author: Andreas Herrmann <andreas.herrmann3@amd.com>
> Date:   Thu Feb 24 15:53:46 2011 +0100
> 
>     x86 quirk: Fix polarity for IRQ0 pin2 override on SB800 systems
>     
>     On some SB800 systems polarity for IOAPIC pin2 is wrongly
>     specified as low active by BIOS. This caused system hangs after
>     resume from S3 when HPET was used in one-shot mode on such
>     systems because a timer interrupt was missed (HPET signal is
>     high active).
>     
>     For more details see:
>     
>       http://marc.info/?l=linux-kernel&m=129623757413868
>     
>     Tested-by: Manoj Iyer <manoj.iyer@canonical.com>
>     Tested-by: Andre Przywara <andre.przywara@amd.com>
>     Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
>     Cc: Borislav Petkov <borislav.petkov@amd.com>
>     Cc: stable@kernel.org # 37.x, 32.x
>     LKML-Reference: <20110224145346.GD3658@alberich.amd.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> :040000 040000 918adb3e08ef8cd258016dc46afab842e1be65fc 77d76d6f2451b16f963ce1ffe183aacfed9d994d M	arch
> [~/repository/kernel]$ 
> --------------------
> 
> So, I Cc to Andreas Herrmann, hope you will notice and help fix this.
> 
> Thanks, all you hackers!
> 
> -- 
> Regards,
> Lei
> 

-- 
Operating | Advanced Micro Devices GmbH
  System  | Einsteinring 24, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Alberto Bozzo, Andrew Bowd
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


