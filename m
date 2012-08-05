Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2HEPwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 11:52:20 -0400
Received: from mail.profihost.ag ([85.158.179.208]:46959 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab2HEPwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 11:52:18 -0400
Message-ID: <501E96BB.5060702@profihost.ag>
Date: Sun, 05 Aug 2012 17:52:27 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: mtosatti@redhat.com, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: KVM segfaults with 3.5 while installing ubuntu 12.04
References: <5017C8A0.60506@profihost.ag> <5017F19E.4070308@redhat.com> <501817C9.6090405@profihost.ag> <5018EC7D.9090702@redhat.com> <5018F5BB.9070500@profihost.ag> <5018F7E6.4020909@redhat.com> <5018F9F6.70307@profihost.ag> <5018FC9B.8040808@redhat.com> <501E4615.7060801@profihost.ag> <501E4AFD.3020806@redhat.com>
In-Reply-To: <501E4AFD.3020806@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by s.priebe@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.08.2012 12:29, schrieb Avi Kivity:
> On 08/05/2012 01:08 PM, Stefan Priebe wrote:
>> Am 01.08.2012 11:53, schrieb Avi Kivity:
>>> On 08/01/2012 12:42 PM, Stefan Priebe - Profihost AG wrote:
>>>> Am 01.08.2012 11:33, schrieb Avi Kivity:
>>>>>> So here are 3 backtraces from booting the rescue system:
>>>>>> http://pastebin.com/raw.php?i=xCy2pEcP
>>>>>>
>>>>>> To me they all look the same.
>>>>>
>>>>> They are.  What version of qemu are you using?
>>>>
>>>> latest stable-1.1 branch (1.1.1) - which works fine with latest RHEL6
>>>> kernel.
>>>
>>> This could be due to a kernel bug, or due to a different code path taken
>>> in qemu because of differing features exposed to kvm.
>>>
>>> Please try qemu-kvm.git master and report.
>>
>> qemu-kvm.git master just hangs after the 2nd screen with using 100% CPU
>> and doing nothing... so i can't test with qemu-kvm.master
>
> Please provide your command line and I will try to reproduce.

ulimit -c unlimited; /usr/bin/qemu-x86_64 -chardev 
socket,id=qmp,path=/var/run/qemu-server/103.qmp,server,nowait -mon 
chardev=qmp,mode=control -pidfile /var/run/qemu-server/103.pid 
-daemonize -usbdevice tablet -name kvmcrash -smp sockets=1,cores=8 
-nodefaults -boot menu=on -vga cirrus -k de -drive 
file=/dev/VGiSCSItarget0/vm-103-disk-1,if=none,id=drive-virtio0,aio=native,cache=none 
-device 
virtio-blk-pci,drive=drive-virtio0,id=virtio0,bus=pci.0,addr=0xa,bootindex=100 
-drive 
file=/var/lib/vz/template/iso/ubuntu-12.04-server-amd64.iso,if=none,id=drive-ide0,media=cdrom,aio=native 
-device ide-cd,bus=ide.0,unit=0,drive=drive-ide0,id=ide0,bootindex=200 
-m 4096 -netdev 
type=tap,id=net0,ifname=tap103i0,script=/var/lib/qemu-server/pve-bridge,vhost=on 
-device 
virtio-net-pci,mac=BA:5B:86:AD:14:3A,netdev=net0,bus=pci.0,addr=0x12,id=net0,bootindex=300

> Which iso image are you running?
ubuntu-12.04-server-amd64.iso
