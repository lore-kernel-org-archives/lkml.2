Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1KFPgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 10:36:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033Ab1KFPf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 10:35:58 -0500
Message-ID: <4EB6A958.9030007@redhat.com>
Date: Sun, 06 Nov 2011 17:35:52 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Xiao Guangrong <xiao.grong@gmail.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/11] KVM: x86: optimize for writing guest page
References: <4E7AF758.7060900@cn.fujitsu.com> <20111006175333.GA3959@amt.cnet> <4E8FCC37.8090409@cn.fujitsu.com> <4E91926D.8060206@redhat.com> <4E91A3AA.1000309@redhat.com> <4E940018.1010908@cn.fujitsu.com> <4EB3AD54.9050605@gmail.com>
In-Reply-To: <4EB3AD54.9050605@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2011 11:16 AM, Xiao Guangrong wrote:
>
> I have done kernbench tests several times on my desktop, but it shows
> very well:
>
> before patchset:
> real 212.27
> real 213.47
> real 204.99
> real 200.58
> real 199.99
> real 199.94
> real 201.51
> real 199.83
> real 198.19
> real 205.13
>
> after patchset:
> real 199.90
> real 201.89
> real 194.54
> real 188.71
> real 185.75
> real 187.70
> real 188.99
> real 188.53
> real 186.29
> real 188.25
>
> I will test it on our server using kvm-autotest, could you share me
> your config file please?


# Copy this file to tests.cfg and edit it.
#
# This file contains the test set definitions. Define your test sets here.

include base.cfg
include subtests.cfg
include guest-os.cfg
include cdkeys.cfg

extra_params += ' -enable-kvm'
image_name(_.*)? ?<= /images/autotest/
#cdrom(_.*)? ?<= isos/

# Modify/comment the following lines if you wish to modify
# the paths of the image files, ISO files, step files or qemu binaries.
#
# As for the defaults:
# * qemu and qemu-img are expected to be found under /usr/bin/qemu-kvm and
#   /usr/bin/qemu-img respectively.
# * All image files are expected under /tmp/kvm_autotest_root/images/
# * All iso files are expected under /tmp/kvm_autotest_root/isos/
# * All step files are expected under /tmp/kvm_autotest_root/steps/
#image_name.* ?<= images/
#cdrom.* ?<= isos/

drive_cache = writeback
# -no-kvm-irqchip
#timeout_multiplier = 8

#iterations = 30

vga = cirrus

# Here are the test sets variants. The variant 'qemu_kvm_windows_quick' is
# fully commented, the following ones have comments only on noteworthy
points
variants:
    - @avi:
        only no_pci_assignable
        only qcow2
        only ide
        #only default
        only smp2
        #only up
        only Fedora.9.32 Fedora.9.64 WinVista.64sp1 WinXP
        only install setup boot reboot migrate shutdown
        only rtl8139
        only smallpages
        #only default_host   

no migrate.exec

# Uncomment the following lines to enable abort-on-error mode:
# abort_on_error = yes
kill_vm.* ?= no
kill_unresponsive_vms.* ?= no

WinXP.64:
    no shutdown
    no reboot

Win2003.64:
    no shutdown
    no reboot

# Choose your test list from the testsets defined
only avi

pci_assignable = no

serial_console = no


-- 
error compiling committee.c: too many arguments to function

