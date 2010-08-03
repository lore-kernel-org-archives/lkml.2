Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab0HCNnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:43:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:49888 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588Ab0HCNni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:43:38 -0400
From: Kumar Gala <galak@kernel.crashing.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: setting up of platform device archdata?
Date: Tue, 3 Aug 2010 08:43:30 -0500
Message-Id: <8AD41167-5FB1-4C42-83A7-9F0CC6AF69AA@kernel.crashing.org>
Cc: "linuxppc-dev@ozlabs.org list" <linuxppc-dev@ozlabs.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
To: Greg KH <greg@kroah.com>
Mime-Version: 1.0 (Apple Message framework v1081)
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

We are running into in issue in that we need the platform device archdata setup before platform_device_add gets called since we need some data in archdata setup to allow the bus notifiers to work properly.  On PPC we need this to get the dma masks setup properly that we than use in the bus notifiers to determine if we need SWIOTLB support for a given device or not.  Any suggestions on how to do this? Something like below?

struct platform_device *platform_device_alloc(const char *name, int id)

...
        if (pa) {
                strcpy(pa->name, name);
                pa->pdev.name = pa->name;
                pa->pdev.id = id;
                device_initialize(&pa->pdev.dev);
                pa->pdev.dev.release = platform_device_release;
#ifdef ARCH_HAS_PDEV_ARCHDATA_SETUP
		arch_setup_pdev_archdata(&pa->pdev.dev);
#endif
        }

- k