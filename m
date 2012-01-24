Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab2AXRUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 12:20:37 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59381 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab2AXRUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 12:20:36 -0500
Message-ID: <4F1EE861.4030405@monstr.eu>
Date: Tue, 24 Jan 2012 18:20:33 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ohad Ben-Cohen <ohad@wizery.com>,
        John Williams <john.williams@petalogix.com>
Subject: remoteproc: Load coprocessor code to the specific main memory location
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a question how to setup resource table to support firmware loading
to specific memory location.
I have allocated the part of ram which is at physical address 0x0
which coprocessor needs for rtos code.

Currently I am using carveout with setup size but from rproc_handle_carveout
is __dma_alloc_buffer which is remapped by __dma_alloc_remap function to any
0xffc00000 address. But IRC this could be useful for system with iommu which we don't have.
devmem entry is the same case.
Coprocessor can directly access memory of the main cpu.

Please correct me if I am wrong but the whole code is designed to use carveout
and remap it to coprocessor address space to requested memory location.

Is there any option how to handle these cases?
For example extending resource type to support direct mapping to preallocated space or so.

Thanks for your comments,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
