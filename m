Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab2G3DY0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 23:24:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab2G3DYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 23:24:25 -0400
Message-ID: <5015FEF3.5040703@redhat.com>
Date: Mon, 30 Jul 2012 11:26:43 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Sasha Levin <levinsasha928@gmail.com>, mashirle@us.ibm.com,
        krkumar2@in.ibm.com, habanero@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        akong@redhat.com, kvm@vger.kernel.org, sri@us.ibm.com
Subject: Re: [net-next RFC V5 4/5] virtio_net: multiqueue support
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com> <1341484194-8108-5-git-send-email-jasowang@redhat.com> <20120720134014.GD16550@redhat.com> <500A9A72.20507@gmail.com> <20120729094451.GB8977@redhat.com>
In-Reply-To: <20120729094451.GB8977@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2012 05:44 PM, Michael S. Tsirkin wrote:
> On Sat, Jul 21, 2012 at 02:02:58PM +0200, Sasha Levin wrote:
>> On 07/20/2012 03:40 PM, Michael S. Tsirkin wrote:
>>>> -	err = init_vqs(vi);
>>>>> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
>>>>> +		vi->has_cvq = true;
>>>>> +
>>> How about we disable multiqueue if there's no cvq?
>>> Will make logic a bit simpler, won't it?
>> multiqueues don't really depend on cvq. Does this added complexity really justifies adding an artificial limit?
> Well !cvq support is a legacy feature: the reason we support it
> in driver is to avoid breaking on old hosts. Adding more code to that
> path just doesn't make much sense since old hosts won't have mq.
>

After some thought about this, maybe there's no need to the cvq for the 
negotiation if we want support only two modes ( 1 tx/rx queue pair and N 
tx/rx queue pairs). We can do this just through the feature bit negotiation.
