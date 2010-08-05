Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102Ab0HEUw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:52:59 -0400
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:45378 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab0HEUwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:52:55 -0400
From: Anjali Kulkarni <anjali@juniper.net>
To: Avi Kivity <avi@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Thu, 5 Aug 2010 13:51:33 -0700
Subject: Re: Freebsd image from Qemu hangs on booting in KVM
Thread-Topic: Freebsd image from Qemu hangs on booting in KVM
Thread-Index: Acs0esE9USofnu+5TxCt4CKr49GvUQAZTtVs
Message-ID: <C8807265.2600D%anjali@juniper.net>
In-Reply-To: <4C5A7A7A.9040909@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-Entourage/13.3.0.091002
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Avi,
I am trying to reproduce this on another setup, and do not see the issue.
My understanding is to run KVM + Qemu, I only need to install KVM modules,
and Qemu does not need to be modified. Is that correct?
I see 

[root@ipg-virt01 anjali]# lsmod | grep kvm
kvm_intel              87016  0
kvm                   211496  1 kvm_intel

[root@ipg-virt01 anjali]# modprobe -l 'kvm*'
/lib/modules/2.6.18-164.el5/kernel/extra/kvm.ko
/lib/modules/2.6.18-164.el5/kernel/extra/kvm-amd.ko
/lib/modules/2.6.18-164.el5/kernel/extra/kvm-intel.ko

And then I run Qemu, as I did, before installing KVM. It should just use
KVM? Is there any way I can check?

Btw, when it hangs, I cannot even press any key, so not sure how I can get
those commands you suggest below..

Anjali

On 8/5/10 1:46 AM, "Avi Kivity" <avi@redhat.com> wrote:

>   On 08/05/2010 05:20 AM, Anjali Kulkarni wrote:
>> Hi,
>> 
>> I have a problem similar to the one seen on this list before - when I boot my
>> freebsd based(but modified) image in Qemu with KVM on CentOS, then after
>> almost booting completely, the image hangs - just before the login prompt is
>> seen. If I do not have KVM ie plain CenOS with Qemu, then this issue does not
>> occur. Has anyone seen this before and any ideas how to debug this?
> 
> First step is to issue 'info registers' and 'x/30i $eip-20' from the
> monitor when it hangs (qemu -monitor stdio makes cut'n'paste easier).

