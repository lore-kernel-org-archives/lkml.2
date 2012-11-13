Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab2KMUwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 15:52:32 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:41771 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864Ab2KMUwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:52:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-acpi@vger.kernel.org
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        mathias.nyman@linux.intel.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 0/3 rev 2] Centralized parsing of ACPI device resources
Date: Tue, 13 Nov 2012 21:51:39 +0100
Message-ID: <5953163.ZajFIHZXph@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <2429141.J1r7BIpiiT@vostro.rjw.lan>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <2429141.J1r7BIpiiT@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 12, 2012 12:51:32 PM Rafael J. Wysocki wrote:
> On Saturday, November 03, 2012 09:46:30 AM Mika Westerberg wrote:
> > Hi,
> > 
> > With ACPI 5 we can now describe how devices are connected to their bus
> > using new resources: SPISerialBus and I2CSerialBus. Also it is now possible
> > to add GPIO connections for the devices with the help of GpioIO and GpioInt
> > resources.
> > 
> > This series adds support for these new resources.
> > 
> > The series based on the ACPI 5 enumeration support patches that are available
> > on Rafael's linux-next branch:
> > 
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next	
> > 
> > Specifically patches from this thread:
> > 
> > 	https://lkml.org/lkml/2012/10/31/154
> > 
> > Since these patches depend on the above patches on Rafael's linux-next branch
> > I suggest that these be merged via that branch, if there are no objections.
> > 
> > The series follows the Device Tree way so that it would be easy to add ACPI
> > support for the existing SPI and I2C drivers if one is familiar how the
> > corresponding DT support is done.
> > 
> > For GPIO we introduce a function that maps between ACPI GPIO numbers and Linux
> > ones - acpi_get_gpio().
> > 
> > SPI slave devices gets enumerated automatically if the master device has
> > master->dev.acpi_handle set (this is analogous to master->dev.of_mode). The
> > platform bus code in Rafael's branch assigns the ACPI handle to the master
> > device.
> > 
> > I2C slave devices can be enumerated by calling acpi_i2c_register_devices() in
> > the adapter driver.
> 
> Following the previous discussion, the patches below move some ACPI resources
> parsing code from drivers/pnp/pnpacpi/rsparser.c to a new file
> drivers/acpi/resource.c and reformat it so that it can be used by other
> subsystems (patch [1/3]), convert the new ACPI platform devices creation
> code to use the routines in drivers/acpi/resource.c instead of doing its
> own resource parsing (patch [2/3]) and make the ACPI namespace scan attach
> a list of _CRS resources to each struct acpi_device it creates, where
> applicable (patch [3/3] - the ACPI platform device code is converted to use
> that instead of executing _CRS by itself via acpi_walk_resources()).
> 
> The patchset is on top of the current linux-pm.git/linux-next branch and
> has been tested somewhat.  Please let me know if you find any problems in it.

Updated series, taking the Mika's feedback into account, follows.  There are
bug fixes in [1/3], [2/3] is unchanged and the new [3/3] is a replacement, done
in a different way because of some ACPICA limitations I didn't realize before.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
