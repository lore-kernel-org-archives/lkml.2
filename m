Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030979Ab2HIPNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:13:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44791 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030816Ab2HIPNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:13:52 -0400
Message-ID: <5023D3A1.8040102@redhat.com>
Date: Thu, 09 Aug 2012 17:13:37 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: mst@redhat.com, mashirle@us.ibm.com, krkumar2@in.ibm.com,
        habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        kvm@vger.kernel.org, sri@us.ibm.com
Subject: Re: [net-next RFC V5 3/5] virtio: intorduce an API to set affinity
 for a virtqueue
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com> <1341484194-8108-4-git-send-email-jasowang@redhat.com>
In-Reply-To: <1341484194-8108-4-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/07/2012 12:29, Jason Wang ha scritto:
> Sometimes, virtio device need to configure irq affiniry hint to maximize the
> performance. Instead of just exposing the irq of a virtqueue, this patch
> introduce an API to set the affinity for a virtqueue.
> 
> The api is best-effort, the affinity hint may not be set as expected due to
> platform support, irq sharing or irq type. Currently, only pci method were
> implemented and we set the affinity according to:
> 
> - if device uses INTX, we just ignore the request
> - if device has per vq vector, we force the affinity hint
> - if the virtqueues share MSI, make the affinity OR over all affinities
>  requested
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

It looks like both I and Jason will need these patches during the 3.7
merge window, and from different trees (net-next vs. scsi).  How do we
synchronize?

Paolo
