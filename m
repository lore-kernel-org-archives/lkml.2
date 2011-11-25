Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab1KYCfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 21:35:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60123 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1KYCfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 21:35:36 -0500
From: Liu Ping Fan <kernelfans@gmail.com>
To: kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, aliguori@us.ibm.com,
        jan.kiszka@web.de, ryanh@us.ibm.com
Subject: [PATCH 0] A series patches for kvm&qemu to enable vcpu destruction in kvm
Date: Fri, 25 Nov 2011 10:35:21 +0800
Message-Id: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A series of patches from kvm, qemu to guest. These patches will finally enable vcpu destruction in kvm instance and let vcpu thread exit in qemu.
 
Currently, the vcpu online feature enables the dynamical creation of vcpu and vcpu thread, while the offline feature can not destruct the vcpu and let vcpu thread exit, it just halt in kvm. Because currently, the vcpu will only be destructed when kvm instance is destroyed. We can 
change vcpu as an refer of kvm instance, and then vcpu's destruction MUST and CAN come before kvm's destruction.

These patches use guest driver to notify the CPU_DEAD event to qemu, and later qemu asks kvm to release the dead vcpu and finally exit the 
thread. 
The usage is: 
	qemu$cpu_set n online
	qemu$cpu_set n zap   ------------ This will destroy the vcpu-n in kvm and let vcpu thread exit
     OR	
	qemu$cpu_set n offline 	--------- This will just block vcpu-n in kvm

Any comment and suggestion are welcome.


Patches include:
|-- guest
|   `-- 0001-virtio-add-a-pci-driver-to-notify-host-the-CPU_DEAD-.patch
|-- kvm
|   |-- 0001-kvm-make-vcpu-life-cycle-separated-from-kvm-instance.patch
|   `-- 0002-kvm-exit-to-userspace-with-reason-KVM_EXIT_VCPU_DEAD.patch
`-- qemu
    |-- 0001-Add-cpu_phyid_to_cpu-to-map-cpu-phyid-to-CPUState.patch
    |-- 0002-Add-cpu_free-to-support-arch-related-CPUState-releas.patch
    |-- 0003-Introduce-a-pci-device-cpustate-to-get-CPU_DEAD-even.patch
    |-- 0004-Release-vcpu-and-finally-exit-vcpu-thread-safely.patch
    `-- 0005-tmp-patches-for-linux-header-files.patch

