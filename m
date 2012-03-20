Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643Ab2CTLLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 07:11:20 -0400
Received: from nat.nue.novell.com ([195.135.221.2]:42878 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab2CTLLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 07:11:17 -0400
Subject: Re: [PATCH] Added backlight driver for Acer Aspire 4736
From: joeyli <jlee@suse.com>
To: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, rpurdie@rpsys.net,
        FlorianSchandinat@gmx.de, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1332122514.10557.270.camel@linux-s257.site>
References: <1331608337.2267.67.camel@debian.Gayathri>
	 <20120312175130.GA18002@srcf.ucam.org>
	 <1331640592.3485.50.camel@debian.Gayathri>
	 <20120313124738.GB10822@srcf.ucam.org>
	 <CABNxG=Dqg26EHmC3vibf3-SjVhby1qgQfMniQObUeh9eJ6SwEw@mail.gmail.com>
	 <20120313133458.GA11574@srcf.ucam.org>
	 <1331688294.2577.19.camel@debian.Gayathri>
	 <1331680373.10557.169.camel@linux-s257.site>
	 <1331692996.3052.8.camel@debian.Gayathri>
	 <1331704278.10557.190.camel@linux-s257.site>
	 <CABNxG=D3y2GQqS1XN=+B0QRScXpufBkPQtP5-SSNEjSavhtW7g@mail.gmail.com>
	 <1331798740.10557.245.camel@linux-s257.site>
	 <1332047432.6304.13.camel@debian.Gayathri>
	 <1332122514.10557.270.camel@linux-s257.site>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Mar 2012 19:09:24 +0800
Message-ID: <1332241764.10557.329.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 一，2012-03-19 於 10:01 +0800，joeyli 提到：
> 於 日，2012-03-18 於 10:40 +0530，Pradeep Subrahmanion 提到：
> > On Thu, 2012-03-15 at 16:05 +0800, joeyli wrote:
> > > Hi Pradeep, 
> > > 
> > > 於 三，2012-03-14 於 11:47 +0530，Pradeep Subrahmanion 提到：
> > > > On Wed, Mar 14, 2012 at 11:21 AM, joeyli <jlee@suse.com> wrote:
> > > > > 於 三，2012-03-14 於 08:13 +0530，Pradeep Subrahmanion 提到：
> > > > >> Hi Joey ,
> > > > >>
> > > > >> > Per my understood, EC firmware should change brightness but didn't do
> > > > >> > that, another
> > > > >> > way is touch i915 register in _BCM.
> > > > >>
> > > > >>   how do we do this ? you mean change the _BCM implementation ?
> > > > >
> > > > > "BIOS guy" should do something like this:
> > > > >
> > > > >  Method (AINT, 2, NotSerialized)
> > > > > {
> > > > > ...
> > > > >        If (LEqual (Arg0, One))
> > > > >        {
> > > > >            Store (Divide (Multiply (Arg1, 0xFF), 0x64, ), BCLP)
> > > > >            Or (BCLP, 0x80000000, BCLP)         <=== touch BCLP register
> > > > >            Store (0x02, ASLC)
> > > > >        }
> > > > >
> > > > >    Method (_BCM, 1, NotSerialized)
> > > > >    {
> > > > >        If (LAnd (LGreaterEqual (Arg0, Zero), LLessEqual (Arg0, 0x64)))
> > > > >        {
> > > > >            AINT (One, Arg0)     <=== call AINT method
> > > > >            Store (Arg0, BRTL)
> > > > >        }
> > > > >    }
> > > > >
> > > > >
> > > > > Just for reference, they should do that when EC didn't wire to
> > > > > backlight.
> > > > >
> > > > >> >
> > > > >> > Acer machine provide a broken _BCM implementation and they didn't test
> > > > >> > it.
> > > > >> >
> > > > >> > > > > By ' ACPI interface' , I mean 'acpi_video0' inside the
> > > > >> > > > > /sys/class/backlight. I havn't tried the /sys/class/backlight interface
> > > > >> > > > > directly . I will try that also.
> > > > >> > > >
> > > > >> > > > So writing values into /sys/class/backlight/acpi_video0/brightness does
> > > > >> > > > nothing?
> > > > >> > >
> > > > >> > >
> > > > >> > > No change in value when writing
> > > > >> > > to /sys/class/backlight/acpi_video0/brightness.
> > > > >> > >
> > > > >> > > Another thing is that when i did boot with acpi_backlight = 'acer_wmi' ,
> > > > >> > > in new kernel (3.3.0-rc7) , it shows following messages ,
> > > > >> > >
> > > > >> > > [    8.350825] wmi: Mapper loaded
> > > > >> > > [   10.363975] acer_wmi: Acer Laptop ACPI-WMI Extras
> > > > >> > > [   10.396186] acer_wmi: Function bitmap for Communication Device: 0x91
> > > > >> > > [   10.396385] acer_wmi: Brightness must be controlled by generic video
> > > > >> > > driver
> > > > >> > >
> > > > >> > > Also there was no interface inside /sys/class/backlight for acer_wmi.
> > > > >> > >
> > > > >> >
> > > > >> > Yes, acer_wmi support backlight control with AMW0 interface, your
> > > > >> > machine didn't have AMW0 interface.
> > > > >> >
> > > > >> > Normally, backlight should control by standard acpi interface.
> > > > >> >
> > > > >> > > I also tried writing directly to Embedded controller register .But no
> > > > >> > > change.
> > > > >> >
> > > > >> > The machine has broken _BCM method, because EC should do something after
> > > > >> > _BCM changed EC register.
> > > > >>
> > > > >> Thanks ,
> > > > >>
> > > > >> Pradeep Subrahmanion
> > > > >
> > > > > Why they didn't find _BCM not work?
> > > > >
> > > > > My guess is:
> > > > >
> > > > > Because the backlight control is through WDDM driver on Windows platform
> > > > > but not through standard ACPI method _BCM. They only test Windows
> > > > > platform, so, they didn't find _BCM broken.
> > > > >
> > > > > And, they also didn't really follow Microsoft WDDM spec:
> > > > >
> > > > >  http://msdn.microsoft.com/en-us/windows/hardware/gg487382.aspx
> > > > >
> > > > > Per spec,
> > > > > ODM should keep _BCM works fine for any other OS didn't support WDDM
> > > > > driver, but they didn't.
> > > > >
> > > > > At last year, I told Acer PM one time for this issue, they said will
> > > > > check but finally didn't response me.
> > > > >
> > > > 
> > > > >
> > > > > Thanks
> > > > > Joey Lee
> > > > >
> > > > 
> > > > So touching the PCI LBB register is the only feasible solution now
> > > > (even though it may not be a clean  method) ?
> > > > 
> > > > Thanks,
> > > > Pradeep Subrahmanion
> > > 
> > > That will be better leave LBB register only touched by i915 driver.
> > > 
> > > If 'acpi_backlight=vendor' works to you, maybe we can add a quirk to
> > > video_detect.c. 
> > > You can try the following patch.
> > 
> > Thanks . I tried your patch .acpi_backlight=vendor allows me to control
> > brightness with hot key.But there are problems with it like increasing
> 
> OK, thanks for your testing, I will send out patch and add Cc. to you.
> 

Could you please kindly try this new patch? I follow Matthew's kindly
suggestion put the quirk table to acer-wmi driver.

Please help to apply the following patch to acer-wmi and remember remove
my last patch of video_detect.c, then rebuild your kernel.

Hope this patch also can fix your problem.


Thanks a lot!
Joey Lee

>From 5da43d2ee6c87dcf17fda34f0b50fe11b04a16bf Mon Sep 17 00:00:00 2001
From: "Lee, Chun-Yi" <jlee@suse.com>
Date: Tue, 20 Mar 2012 19:00:58 +0800
Subject: [PATCH] acer-wmi: add quirk table for video backlight vendor mode

There have some acer laptop have broken _BCM implemenation, the AML
code wrote value to EC register but firmware didn't change brighenss.

Fortunately, the brightness control works on those machines with
vendor mode. So, add quirk table for video backlight vendor mode
and unregister acpi video interface on those machines.

Tested on Acer TravelMate 4750

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/platform/x86/Kconfig    |    4 ++++
 drivers/platform/x86/acer-wmi.c |   38 +++++++++++++++++++++++++++++++++++---
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 15dbd8c..fe3a494 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -26,6 +26,10 @@ config ACER_WMI
 	depends on RFKILL || RFKILL = n
 	depends on ACPI_WMI
 	select INPUT_SPARSEKMAP
+	# Acer WMI depends on ACPI_VIDEO when ACPI is enabled
+	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
+        select VIDEO_OUTPUT_CONTROL if ACPI
+        select ACPI_VIDEO if ACPI
 	---help---
 	  This is a driver for newer Acer (and Wistron) laptops. It adds
 	  wireless radio and bluetooth control, and on some laptops,
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 1e5290b..984a7b5 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -43,6 +43,7 @@
 #include <linux/input/sparse-keymap.h>
 
 #include <acpi/acpi_drivers.h>
+#include <acpi/video.h>
 
 MODULE_AUTHOR("Carlos Corbacho");
 MODULE_DESCRIPTION("Acer Laptop WMI Extras Driver");
@@ -478,6 +479,33 @@ static struct dmi_system_id acer_quirks[] = {
 	{}
 };
 
+static int video_set_backlight_video_vendor(const struct dmi_system_id *d)
+{
+	interface->capability &= ~ACER_CAP_BRIGHTNESS;
+	pr_info("Brightness must be controlled by generic video driver\n");
+	return 0;
+}
+
+static const struct dmi_system_id video_vendor_dmi_table[] = {
+	{
+		.callback = video_set_backlight_video_vendor,
+		.ident = "Acer Aspire 4736",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 4736"),
+		},
+	},
+	{
+		.callback = video_set_backlight_video_vendor,
+		.ident = "Acer TravelMate 4750",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 4750"),
+		},
+	},
+	{}
+};
+
 /* Find which quirks are needed for a particular vendor/ model pair */
 static void find_quirks(void)
 {
@@ -1981,9 +2009,13 @@ static int __init acer_wmi_init(void)
 	set_quirks();
 
 	if (acpi_video_backlight_support()) {
-		interface->capability &= ~ACER_CAP_BRIGHTNESS;
-		pr_info("Brightness must be controlled by "
-		       "generic video driver\n");
+		if (dmi_check_system(video_vendor_dmi_table)) {
+			acpi_video_unregister();
+		} else {
+			interface->capability &= ~ACER_CAP_BRIGHTNESS;
+			pr_info("Brightness must be controlled by "
+				"acpi video driver\n");
+		}
 	}
 
 	if (wmi_has_guid(WMID_GUID3)) {
-- 
1.7.7



