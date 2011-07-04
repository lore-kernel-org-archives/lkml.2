Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab1GDKIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 06:08:07 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:42478 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754284Ab1GDKIE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 06:08:04 -0400
From: "Jaju, Ganesh" <Ganesh.Jaju@lsi.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 4 Jul 2011 15:37:58 +0530
Subject: Continuous mmap & unmap of kernel buffers leading to memory leak on
 linux kernel 2.6.38
Thread-Topic: Continuous mmap & unmap of kernel buffers leading to memory
 leak on linux kernel 2.6.38
Thread-Index: AQHMOjI/ahqPTy0xb06KdFmMqqBr2Q==
Message-ID: <11309A76DCEC0041BEB858FDC83272E6015B1A73E8@inbmail01.lsi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have a driver that supports mmap of kernel buffers to the user space.
The user space application continuously mmaps and unmaps lot of memory.
This piece of code works fine on linux kernel 2.6.9 while same code gives huge memory leaks on linux kernel 2.6.38 finally leading to system memory allocation failure.
I am suspecting that the mmap’ed pages are not getting unmapped at all.

The nopage() routine (fault() routine for linux kernel version >= 2.6.26) of the vma operations increments the page count of the page that has been requested/accessed before returning the required page.
As I am seeing it, on linux kernel 2.6.9, when the vmaclose() routine gets called, the page count in 2.6.9 kernel is ‘0’ while in 2.6.38 it is ‘1’.
To my knowledge, the unmap routine itself decrements the page count of each of the pages. But, somehow for 2.6.38, the page count is ‘1’ even when the vmaclose() routine gets called.
I even tried decrementing the page count in vmaclose() routine for 2.6.38 kernel. But, the memory leak continues.

Am I missing something here or has something changed in the linux kernel in this path?

Thanks & Regards
Ganesh Jaju.
