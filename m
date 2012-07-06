Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2GFHo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:44:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab2GFHoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:44:54 -0400
Message-ID: <4FF697EA.807@redhat.com>
Date: Fri, 06 Jul 2012 15:46:50 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: Amos Kong <akong@redhat.com>
CC: Sasha Levin <levinsasha928@gmail.com>, mst@redhat.com, mashirle@us.ibm.com,
        krkumar2@in.ibm.com, habanero@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        kvm@vger.kernel.org, sri@us.ibm.com
Subject: Re: [net-next RFC V5 5/5] virtio_net: support negotiating the number
 of queues through ctrl vq
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com>  <1341484194-8108-6-git-send-email-jasowang@redhat.com> <1341492679.18786.18.camel@lappy> <4FF5F3F7.8090307@redhat.com>
In-Reply-To: <4FF5F3F7.8090307@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 04:07 AM, Amos Kong wrote:
> On 07/05/2012 08:51 PM, Sasha Levin wrote:
>> On Thu, 2012-07-05 at 18:29 +0800, Jason Wang wrote:
>>> @@ -1387,6 +1404,10 @@ static int virtnet_probe(struct virtio_device *vdev)
>>>          if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
>>>                  vi->has_cvq = true;
>>>
>
>>> +       /* Use single tx/rx queue pair as default */
>>> +       vi->num_queue_pairs = 1;
>>> +       vi->total_queue_pairs = num_queue_pairs;
> vi->total_queue_pairs also should be set to 1
>
>             vi->total_queue_pairs = 1;

Hi Amos:

total_queue_pairs is the max number of queue pairs that the deivce could 
provide, so it's ok here.
>> The code is using this "default" even if the amount of queue pairs it
>> wants was specified during initialization. This basically limits any
>> device to use 1 pair when starting up.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

