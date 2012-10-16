Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab2JPFGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 01:06:17 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56649 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab2JPFGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 01:06:16 -0400
MIME-Version: 1.0
In-Reply-To: <CA+U0gVjD9mBxR5=r1qv69MHN9b7Dd1PPRnEzchZpYuOU_W1eNw@mail.gmail.com>
References: <CA+U0gVjD9mBxR5=r1qv69MHN9b7Dd1PPRnEzchZpYuOU_W1eNw@mail.gmail.com>
Date: Tue, 16 Oct 2012 13:06:15 +0800
Message-ID: <CA+U0gVjgJn23PNGck7rWG5NEC9PrLYwZhyarmdET5kjw0=twzw@mail.gmail.com>
Subject: Re: CPU utilization between physical CPU and virtual CPU in KVM
From: Dennis Chen <kernel.org.gnu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: qemu-devel@nongnu.org, libvir-list@redhat.com, dennis.chen@tnsoft.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any body can be help about this or  a little bit clues?  Thanks!

On Mon, Oct 8, 2012 at 3:01 PM, Dennis Chen <kernel.org.gnu@gmail.com> wrote:
> Hi All,
>
> I am confused by the following observed scenario:
>
> In my 4-CPU (KVM supported, 2 core with 2 thread for each) host
> machine box, I create only one VM with 3-vCPU through virsh/libvirt
> tools and also I pin this VM process to the physical processor 3. I
> guess the CPU utilization for the processor 3 will not exceed 100%,
> then I create 3 process (dead loop-- while(1);) and bind each of them
> to vCPU[0-2] respectively, through the "top -c" command in VM
> environment, I can see the CPU utilization for each of the vCPU is
> about 100%, but interesting, I found that the CPU utilization of
> processor 3 in the host machine is about 300% with "toc -c" command.
> why does a single process bound to a CPU can get ~300% cpu bandwidth
> in this case, does the kernel scheduler dispatch the idle cycle
> capacity of the CPUs to the virtual CPU of the VM, other word, the
> scheduler knows the vCPU info in the VM process?
>
> For the same case, if I create another 4 new dead-loop processes and
> bind them to the physical CPU[0-3] equally, then I find the vCPU0/1 in
> VM will not be 100%, eg. 32%,  (I think the scheduler in the guest OS
> doesn't know it's running in a virtual environment, so the utilization
> of the vCPU will not change to adapt to the physical processor
> utilization, but it did, why?
>
> -org-gnu
