Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab0LBXlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 18:41:36 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:54671 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab0LBXlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 18:41:35 -0500
Subject: Re: [PATCH 3/3] ideapad: add hotkey support
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1289977238-15113-1-git-send-email-ike.pan@canonical.com>
References: <1289977165-14802-1-git-send-email-ike.pan@canonical.com>
	 <1289977238-15113-1-git-send-email-ike.pan@canonical.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 02 Dec 2010 15:41:27 -0800
Message-ID: <1291333287.10586.4698.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 15:00 +0800, Ike Panhc wrote:
> +static void ideapad_input_report(unsigned long scancode)
> +{
> +       sparse_keymap_report_event(ideapad_priv->inputdev, scancode, 1, true);
> +} 

I got a little build error about some unresolved symbols in the module
while compiling:
        
        ERROR: "sparse_keymap_setup" [drivers/platform/x86/ideapad-laptop.ko] undefined!
        ERROR: "sparse_keymap_free" [drivers/platform/x86/ideapad-laptop.ko] undefined!
        ERROR: "sparse_keymap_report_event" [drivers/platform/x86/ideapad-laptop.ko] undefined!
        
You can get it to go away by setting CONFIG_INPUT_SPARSEKMAP=m or =y
in .config.  But, I think your patches need this:

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index faec777..879d266 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -226,6 +226,7 @@ config IDEAPAD_LAPTOP
 	tristate "Lenovo IdeaPad Laptop Extras"
 	depends on ACPI
 	depends on RFKILL
+	select INPUT_SPARSEKMAP
 	help
 	  This is a driver for the rfkill switches on Lenovo IdeaPad netbooks.
 

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

