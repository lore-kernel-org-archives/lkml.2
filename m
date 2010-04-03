Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab0DCQc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 12:32:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab0DCQcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 12:32:48 -0400
Message-ID: <4BB76DA1.4050904@redhat.com>
Date: Sat, 03 Apr 2010 19:32:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sridhar Samudrala <sri@us.ibm.com>
CC: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, mst@redhat.com,
       jdike@c2.user-mode-linux.org, davem@davemloft.net
Subject: Re: [RFC][PATCH v2 0/3] Provide a zero-copy method on KVM virtio-net.
References: <1270193100-6769-1-git-send-email-xiaohui.xin@intel.com> <1270252268.13897.14.camel@w-sridhar.beaverton.ibm.com>
In-Reply-To: <1270252268.13897.14.camel@w-sridhar.beaverton.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2010 02:51 AM, Sridhar Samudrala wrote:
> On Fri, 2010-04-02 at 15:25 +0800, xiaohui.xin@intel.com wrote:
>    
>> The idea is simple, just to pin the guest VM user space and then
>> let host NIC driver has the chance to directly DMA to it.
>> The patches are based on vhost-net backend driver. We add a device
>> which provides proto_ops as sendmsg/recvmsg to vhost-net to
>> send/recv directly to/from the NIC driver. KVM guest who use the
>> vhost-net backend may bind any ethX interface in the host side to
>> get copyless data transfer thru guest virtio-net frontend.
>>      
> What is the advantage of this approach compared to PCI-passthrough
> of the host NIC to the guest?
>    

swapping/ksm/etc
independence from host hardware
live migration

> Does this require pinning of the entire guest memory? Or only the
> send/receive buffers?
>    

If done correctly, just the send/receive buffers.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

