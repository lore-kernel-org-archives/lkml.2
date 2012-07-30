Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2G3NAC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 09:00:02 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58142 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab2G3M77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 08:59:59 -0400
Message-ID: <5016856D.8060009@gmail.com>
Date: Mon, 30 Jul 2012 15:00:29 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120713 Thunderbird/13.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>, mashirle@us.ibm.com, krkumar2@in.ibm.com,
        habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        akong@redhat.com, kvm@vger.kernel.org, sri@us.ibm.com
Subject: Re: [net-next RFC V5 4/5] virtio_net: multiqueue support
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com> <1341484194-8108-5-git-send-email-jasowang@redhat.com> <20120720134014.GD16550@redhat.com> <500A9A72.20507@gmail.com> <20120729094451.GB8977@redhat.com>
In-Reply-To: <20120729094451.GB8977@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2012 11:44 AM, Michael S. Tsirkin wrote:
> On Sat, Jul 21, 2012 at 02:02:58PM +0200, Sasha Levin wrote:
>> On 07/20/2012 03:40 PM, Michael S. Tsirkin wrote:
>>>> -	err = init_vqs(vi);
>>>>> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
>>>>> +		vi->has_cvq = true;
>>>>> +
>>> How about we disable multiqueue if there's no cvq?
>>> Will make logic a bit simpler, won't it?
>>
>> multiqueues don't really depend on cvq. Does this added complexity really justifies adding an artificial limit?
> 
> Well !cvq support is a legacy feature: the reason we support it
> in driver is to avoid breaking on old hosts. Adding more code to that
> path just doesn't make much sense since old hosts won't have mq.

Is it really a legacy feature? The spec suggests that its an optional queue which is not necessary for the operation of the device.

Which is why we never implemented it in lkvm - we weren't interested in any of the features it provided at that time and we could provide high performance with vhost support even without it.
