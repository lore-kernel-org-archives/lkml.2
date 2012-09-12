Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab2ILIHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:07:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682Ab2ILIGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:06:55 -0400
Message-ID: <50504299.2050205@redhat.com>
Date: Wed, 12 Sep 2012 11:06:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: qemu-kvm loops after kernel udpate
References: <504F7ED8.1030702@suse.cz> <20120911190303.GA3626@amt.cnet> <504F93F1.2060005@suse.cz>
In-Reply-To: <504F93F1.2060005@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 10:41 PM, Jiri Slaby wrote:
> On 09/11/2012 09:03 PM, Marcelo Tosatti wrote:
>> On Tue, Sep 11, 2012 at 08:11:36PM +0200, Jiri Slaby wrote:
>>> Hi,
>>>
>>> it looks like an update from next-20120824 to next-20120910 makes kvm
>>> defunct. When I try to run qemu, it loops forever without printing
>>> anything on the monitor.
>>>
>>> -no-kvm makes it indeed work.
>>>
>>> Cmdline I use:
>>> qemu-kvm -k en-us -usbdevice tablet -balloon virtio -hda IMAGE -smp 2 -m
>>> 1000M -net user -net nic,model=e1000 -usb -serial pty
>>>
>>> Before I start investigating further, like biscection, is this a known
>>> issue already and fix available somewhere?
>> 
>> Its not a known issue. 'info registers' (for both vcpus) and
>> 'x /20i $eip' might help track it down. 
> 
> I don't think it's in a state with something loaded.
> 
> (qemu) cpu 0
> (qemu) info registers
> EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000623
> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
> EIP=0000fff0 EFL=00010002 [-------] CPL=3 II=0 A20=1 SMM=0 HLT=0
> ES =0000 00000000 0000ffff 00009300
> CS =f000 000f0000 0000ffff 0000f300

This is before the first instruction is executed.

You're on an Intel host, yes?  Please provide the output of vmxcap
(http://goo.gl/c5lUO), and a snapshot of kvm_stat while the guest is hung.


-- 
error compiling committee.c: too many arguments to function
