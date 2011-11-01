Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab1KANBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 09:01:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42079 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1KANBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 09:01:44 -0400
Subject: Additional virtio-mmio spec changes
From: Pawel Moll <pawel.moll@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Peter Maydell <Peter.Maydell@arm.com>
Date: Tue, 01 Nov 2011 13:01:39 +0000
Message-ID: <1320152499.3287.197.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 01 Nov 2011 13:01:39.0453 (UTC) FILETIME=[65095AD0:01CC9896]
X-MC-Unique: 111110113014106801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Peter (on Cc) got the qemu implementation up and running (thanks!) and
provided some useful feedback regarding the spec. To make the long story
short, this is what came out of the discussion (feel free to correct me
at any point, Peter ;-):

diff --git a/virtio-spec.lyx b/virtio-spec.lyx
index 6426f8f..79a6498 100644
--- a/virtio-spec.lyx
+++ b/virtio-spec.lyx
@@ -6681,7 +6681,9 @@ s on QueueNum, QueueAlign and QueuePFN apply to.
 
  Writing to this register notifies the Host what size of the queue the Guest
  will use.
- This applies to the queue selected by writing to QueueSel.
+ This applies to the queue selected by writing to QueueSel and is allowed
+ only when QueuePFN is set to zero (0x0), so when the queue is not actively
+ used.
  
 \end_layout
 
@@ -6790,8 +6792,8 @@ This interrupt is asserted when configuration of the device has changed.
 
  Writing to this register notifies the Host that the Guest finished handling
  interrupts.
- Every bit of the value clears corresponding bit of the InterruptStatus
- register.
+ Set bits in the value clear the corresponding bits of the
+ InterruptStatus register.
  
 \end_layout
 
@@ -6975,7 +6977,9 @@ reference "sub:Notifying-The-Device"
 \end_layout
 
 \begin_layout Enumerate
-The memory mapped virtio device is using single, dedicated interrupt signal.
+The memory mapped virtio device is using single, dedicated interrupt signal,
+ which is raised when at least one of the interrupts described in the
+ InterruptStatus register description is asserted.
  After receiving an interrupt, the driver must read the InterruptStatus
  register to check what caused the interrupt (see the register description).
  After the interrupt is handled, the driver must acknowledge it by writing



Of course those changes are not critical so can easily wait till the
next release. Peter also mentioned that he didn't like the "Num" in
"QueueNum" register name and would rather see it called "QueueSize". I
have no strong opinions either way and can provide patches to both the
spec and the driver (and header) to change it. Any thoughts?

Cheers!

Paweł


