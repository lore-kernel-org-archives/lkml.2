Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab2GVLjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 07:39:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58437 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2GVLjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 07:39:35 -0400
Message-ID: <500BE68D.90005@gmail.com>
Date: Sun, 22 Jul 2012 13:39:57 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120713 Thunderbird/13.0
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v7.5] kvm: notify host when the guest is
 panicked
References: <500A565A.8080403@cn.fujitsu.com> <500A6BF1.4030002@cn.fujitsu.com>
In-Reply-To: <500A6BF1.4030002@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2012 10:44 AM, Wen Congyang wrote:
> We can know the guest is panicked when the guest runs on xen.
> But we do not have such feature on kvm.
> 
> Another purpose of this feature is: management app(for example:
> libvirt) can do auto dump when the guest is panicked. If management
> app does not do auto dump, the guest's user can do dump by hand if
> he sees the guest is panicked.
> 
> We have three solutions to implement this feature:
> 1. use vmcall
> 2. use I/O port
> 3. use virtio-serial.
> 
> We have decided to avoid touching hypervisor. The reason why I choose
> choose the I/O port is:
> 1. it is easier to implememt
> 2. it does not depend any virtual device
> 3. it can work when starting the kernel

Was the option of implementing a virtio-watchdog driver considered?

You're basically re-implementing a watchdog, a guest-host interface and a set of protocols for guest-host communications.

Why can't we re-use everything we have now, push a virtio watchdog driver into drivers/watchdog/, and gain a more complete solution to detecting hangs inside the guest.
