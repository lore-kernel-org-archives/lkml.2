Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1K0DHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 22:07:14 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39697 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1K0DHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 22:07:07 -0500
MIME-Version: 1.0
In-Reply-To: <4ECFD645.2060201@web.de>
References: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
	<4ECFD645.2060201@web.de>
Date: Sun, 27 Nov 2011 11:07:07 +0800
Message-ID: <CAFgQCTtJby701XGKDKTcinp9apiaUkWF8Y3Zr0pG=euX83MNoA@mail.gmail.com>
Subject: Re: [PATCH 0] A series patches for kvm&qemu to enable vcpu
 destruction in kvm
From: Liu ping fan <kernelfans@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
        avi@redhat.com, aliguori@us.ibm.com, ryanh@us.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 1:54 AM, Jan Kiszka <jan.kiszka@web.de> wrote:
> On 2011-11-25 00:35, Liu Ping Fan wrote:
>> A series of patches from kvm, qemu to guest. These patches will finally enable vcpu destruction in kvm instance and let vcpu thread exit in qemu.
>>
>> Currently, the vcpu online feature enables the dynamical creation of vcpu and vcpu thread, while the offline feature can not destruct the vcpu and let vcpu thread exit, it just halt in kvm. Because currently, the vcpu will only be destructed when kvm instance is destroyed. We can
>> change vcpu as an refer of kvm instance, and then vcpu's destruction MUST and CAN come before kvm's destruction.
>>
>> These patches use guest driver to notify the CPU_DEAD event to qemu, and later qemu asks kvm to release the dead vcpu and finally exit the
>> thread.
>> The usage is:
>>       qemu$cpu_set n online
>>       qemu$cpu_set n zap   ------------ This will destroy the vcpu-n in kvm and let vcpu thread exit
>>      OR
>>       qemu$cpu_set n offline  --------- This will just block vcpu-n in kvm
>>
>> Any comment and suggestion are welcome.
>
> The cpu_set command will probably not make it to QEMU upstream
> (device_add/delete is the way to go - IMHO). So I would refrain from
> adding anything to qemu-kvm at this point anyway.
>
Ok, I will see more details in device_add/delete.
> Also, what would be> the advantage of 'zap' from user perspective?
>
Suppose we increase one user's cpu's utilization by creating more
threads for them (of course, task_group is another choice), later we
decide to reclaim the utilization from this user, so we remove some of
the vcpu from this user's guest OS. But the related vcpu structure are
not released in kernel in current code, and wasted.
>From another viewpoint, if we can dynamically create the vcpu & vcpu
thread, we had better to have the ability to dynamically destroy them.

>>
>>
>> Patches include:
>> |-- guest
>> |   `-- 0001-virtio-add-a-pci-driver-to-notify-host-the-CPU_DEAD-.patch
>> |-- kvm
>> |   |-- 0001-kvm-make-vcpu-life-cycle-separated-from-kvm-instance.patch
>> |   `-- 0002-kvm-exit-to-userspace-with-reason-KVM_EXIT_VCPU_DEAD.patch
>> `-- qemu
>>     |-- 0001-Add-cpu_phyid_to_cpu-to-map-cpu-phyid-to-CPUState.patch
>>     |-- 0002-Add-cpu_free-to-support-arch-related-CPUState-releas.patch
>>     |-- 0003-Introduce-a-pci-device-cpustate-to-get-CPU_DEAD-even.patch
>>     |-- 0004-Release-vcpu-and-finally-exit-vcpu-thread-safely.patch
>>     `-- 0005-tmp-patches-for-linux-header-files.patch
>>
>
> I only found kvm patch 0001 so far. Something probably went wrong with
> your postings.
>
Sorry, I have resent them, pls re-fetch them .

Thanks and regards,
ping fan

> Jan
>
>
