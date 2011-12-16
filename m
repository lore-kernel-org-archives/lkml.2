Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab1LPHGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 02:06:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40980 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab1LPHF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 02:05:58 -0500
Message-ID: <1324019151.4496.9.camel@lappy>
Subject: Re: [PATCH 0/2] vhot-net: Use kvm_memslots instead of vhost_memory
 to translate GPA to HVA
From: Sasha Levin <levinsasha928@gmail.com>
To: zanghongyong@huawei.com
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        xiaowei.yang@huawei.com, hanweidong@huawei.com, wusongwei@huawei.com
Date: Fri, 16 Dec 2011 09:05:51 +0200
In-Reply-To: <1324013528-3663-1-git-send-email-zanghongyong@huawei.com>
References: <1324013528-3663-1-git-send-email-zanghongyong@huawei.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 13:32 +0800, zanghongyong@huawei.com wrote:
> From: Hongyong Zang <zanghongyong@huawei.com>
> 
> Vhost-net uses its own vhost_memory, which results from user space (qemu) info,
> to translate GPA to HVA. Since kernel's kvm structure already maintains the 
> address relationship in its member *kvm_memslots*, these patches use kernel's 
> kvm_memslots directly without the need of initialization and maintenance of 
> vhost_memory.

Conceptually, vhost isn't aware of KVM - it's just a driver which moves
data from vq to a tap device and back. You can't simply add KVM specific
code into vhost.

Whats the performance benefit?

-- 

Sasha.

