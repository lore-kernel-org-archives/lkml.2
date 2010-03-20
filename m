Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab0CTNLM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 09:11:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab0CTNLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 09:11:03 -0400
Message-ID: <4BA4C961.9060006@redhat.com>
Date: Sat, 20 Mar 2010 15:10:57 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@vmware.com>
CC: linux-kernel@vger.kernel.org, pv-drivers@vmware.com,
       Alok Kataria <akataria@vmware.com>,
       Saileshkumar Jain <sajain@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 4/4] Add VMware memory balloon driver
References: <20100319204628.4418.84674.stgit@localhost.localdomain> <20100319204702.4418.92437.stgit@localhost.localdomain>
In-Reply-To: <20100319204702.4418.92437.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 10:47 PM, Dmitry Torokhov wrote:
> This is a virtio-based transport between VMware's hypervisor
> and virtio_ballon driver that allows host control guest memory
> ballooning.
>
>    

This is a little wierd since it's specific to the balloon driver.  The 
virtio design is to make transport and device orthogonal so we could 
mix'n'match any driver with any transport, but this will only work with 
the balloon driver.  It's also 640 lines while the original balloon 
driver is ~300.  Some of that is because you're emulating a queue that 
doesn't really exist, IIUC.

So while I'd love to see other hypervisors adopt virtio, I think in this 
case it makes more sense to have your own balloon driver.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

