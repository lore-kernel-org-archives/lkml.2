Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab2GWFwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 01:52:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652Ab2GWFwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 01:52:38 -0400
Message-ID: <500CE72B.2040101@redhat.com>
Date: Mon, 23 Jul 2012 13:54:51 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, mashirle@us.ibm.com,
        krkumar2@in.ibm.com, habanero@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        akong@redhat.com, kvm@vger.kernel.org, sri@us.ibm.com
Subject: Re: [net-next RFC V5 4/5] virtio_net: multiqueue support
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com> <1341484194-8108-5-git-send-email-jasowang@redhat.com> <20120720134014.GD16550@redhat.com> <500A9A72.20507@gmail.com>
In-Reply-To: <500A9A72.20507@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2012 08:02 PM, Sasha Levin wrote:
> On 07/20/2012 03:40 PM, Michael S. Tsirkin wrote:
>>> -	err = init_vqs(vi);
>>>> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
>>>> +		vi->has_cvq = true;
>>>> +
>> How about we disable multiqueue if there's no cvq?
>> Will make logic a bit simpler, won't it?
> multiqueues don't really depend on cvq. Does this added complexity really justifies adding an artificial limit?
>

Yes, it does not depends on cvq. Cvq were just used to negotiate the 
number of queues a guest wishes to use which is really useful (at least 
for now). Since multiqueue can not out-perform for single queue in every 
kinds of workloads or benchmark, so we want to let guest driver use 
single queue by default even when multiqueue were enabled by management 
software and let use to enalbe it through ethtool. So user could not 
feel regression when it switch to use a multiqueue capable driver and 
backend.

So the only difference is the user experiences.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

