Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab2JaBdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 21:33:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab2JaBdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 21:33:00 -0400
Date: Tue, 30 Oct 2012 23:12:56 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Hu Tao <hutao@cn.fujitsu.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH v11] kvm: notify host when the guest is panicked
Message-ID: <20121031011256.GC12325@amt.cnet>
References: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 11:42:32AM +0800, Hu Tao wrote:
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

It has been asked earlier why a simple virtio device is not usable
for this (with no response IIRC).

Also, there is no high level documentation: purpose of the interface,
how a management application should use it, etc.

