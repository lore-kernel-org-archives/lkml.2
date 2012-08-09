Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031138Ab2HIPho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:37:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031060Ab2HIPhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:37:42 -0400
Message-ID: <5023D8D1.3060604@redhat.com>
Date: Thu, 09 Aug 2012 18:35:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Jason Wang <jasowang@redhat.com>, mst@redhat.com, mashirle@us.ibm.com,
        krkumar2@in.ibm.com, habanero@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        kvm@vger.kernel.org, sri@us.ibm.com
Subject: Re: [net-next RFC V5 3/5] virtio: intorduce an API to set affinity
 for a virtqueue
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com> <1341484194-8108-4-git-send-email-jasowang@redhat.com> <5023D3A1.8040102@redhat.com>
In-Reply-To: <5023D3A1.8040102@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 06:13 PM, Paolo Bonzini wrote:
> Il 05/07/2012 12:29, Jason Wang ha scritto:
>> Sometimes, virtio device need to configure irq affiniry hint to maximize the
>> performance. Instead of just exposing the irq of a virtqueue, this patch
>> introduce an API to set the affinity for a virtqueue.
>> 
>> The api is best-effort, the affinity hint may not be set as expected due to
>> platform support, irq sharing or irq type. Currently, only pci method were
>> implemented and we set the affinity according to:
>> 
>> - if device uses INTX, we just ignore the request
>> - if device has per vq vector, we force the affinity hint
>> - if the virtqueues share MSI, make the affinity OR over all affinities
>>  requested
>> 
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> It looks like both I and Jason will need these patches during the 3.7
> merge window, and from different trees (net-next vs. scsi).  How do we
> synchronize?

Get one of them to promise not to rebase, merge it, and base your
patches on top of the merge.

-- 
error compiling committee.c: too many arguments to function
