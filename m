Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab1FTICn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 04:02:43 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:55965 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab1FTICe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 04:02:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19966.65175.273917.314279@pilspetsen.it.uu.se>
Date: Mon, 20 Jun 2011 10:02:31 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: newton mailinglist <newtonmailinglist@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PCI Driver Help] Locking Pages of a running process
In-Reply-To: <BANLkTimU=FL-QG9KcGbYOegfizf5HNH+ZQ@mail.gmail.com>
References: <BANLkTimU=FL-QG9KcGbYOegfizf5HNH+ZQ@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

newton mailinglist writes:
 > Hi,
 > 
 > I have written a PCI driver for my device. The device is an FPGA which
 > is configured with a design that allows it to have direct access to
 > memory of a host computer to which the fpga board is connected. My
 > device driver is responsible for translating virtual addresses to
 > physical addresses and sending these to the FPGA so the DMA unit in
 > the FPGA can directly access pages in memory.
 > 
 > I have a C program which uses the driver to open this PCI device and
 > then sends a command to the device, so it can begin accessing
 > memory(for some calculations done in the fpga). This is done via
 > IOCTL. The FPGA sends an interrupt when its done. However my program
 > does not wait for the FPGA but instead resumes execution immmediately
 > after the IOCTL call returns. If the FPGA has a virtual address which
 > it needs to translate, it interrupts my PCI driver and I want to
 > translate this address in the interrupt handler and write back the
 > translated address to the device using memory mapped I/O.
 > 
 > The issue is that when my driver gets the virtual address, it attempts
 > to lock the user space pages first(those of the running C program) in
 > memory using get_user_pages() and then translates the address using
 > pci_map_page(). Pinning the pages in memory is needed as the fpga will
 > access them later using DMA. Here is the code I use   :

Instead of sending user-space pages from an application to the driver,
expecting the driver to do address space translations and locking,
your driver should implement mmap() and user-space should get its I/O
buffers by mmap()ing the device.
