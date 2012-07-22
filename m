Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab2GVTOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 15:14:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47818 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2GVTOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 15:14:18 -0400
From: Anthony Liguori <anthony@codemonkey.ws>
To: Sasha Levin <levinsasha928@gmail.com>, Wen Congyang <wency@cn.fujitsu.com>
Cc: Gleb Natapov <gleb@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Qemu-devel] [PATCH v7.5] kvm: notify host when the guest is panicked
In-Reply-To: <500BE68D.90005@gmail.com>
References: <500A565A.8080403@cn.fujitsu.com> <500A6BF1.4030002@cn.fujitsu.com> <500BE68D.90005@gmail.com>
User-Agent: Notmuch/0.13.2+60~g7ecf77d (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Sun, 22 Jul 2012 14:14:12 -0500
Message-ID: <87wr1vwquz.fsf@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> On 07/21/2012 10:44 AM, Wen Congyang wrote:
>> We can know the guest is panicked when the guest runs on xen.
>> But we do not have such feature on kvm.
>> 
>> Another purpose of this feature is: management app(for example:
>> libvirt) can do auto dump when the guest is panicked. If management
>> app does not do auto dump, the guest's user can do dump by hand if
>> he sees the guest is panicked.
>> 
>> We have three solutions to implement this feature:
>> 1. use vmcall
>> 2. use I/O port
>> 3. use virtio-serial.
>> 
>> We have decided to avoid touching hypervisor. The reason why I choose
>> choose the I/O port is:
>> 1. it is easier to implememt
>> 2. it does not depend any virtual device
>> 3. it can work when starting the kernel
>
> Was the option of implementing a virtio-watchdog driver considered?
>
> You're basically re-implementing a watchdog, a guest-host interface and a set of protocols for guest-host communications.
>
> Why can't we re-use everything we have now, push a virtio watchdog
> driver into drivers/watchdog/, and gain a more complete solution to
> detecting hangs inside the guest.

The purpose of virtio is not to reinvent every possible type of device.
There are plenty of hardware watchdogs that are very suitable to be used
for this purpose.  QEMU implements quite a few already.

Watchdogs are not performance sensitive so there's no point in using
virtio.

Regards,

Anthony Liguori
