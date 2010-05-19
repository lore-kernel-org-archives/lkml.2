Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab0ESRFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:05:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab0ESRFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:05:41 -0400
Message-ID: <4BF41A33.8090309@redhat.com>
Date: Wed, 19 May 2010 20:04:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: davem@davemloft.net, Juan Quintela <quintela@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
       amit.shah@redhat.com
Subject: Re: [PATCH] vhost-net: utilize PUBLISH_USED_IDX feature
References: <20100518011931.GA21918@redhat.com>
In-Reply-To: <20100518011931.GA21918@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 04:19 AM, Michael S. Tsirkin wrote:
> With PUBLISH_USED_IDX, guest tells us which used entries
> it has consumed. This can be used to reduce the number
> of interrupts: after we write a used entry, if the guest has not yet
> consumed the previous entry, or if the guest has already consumed the
> new entry, we do not need to interrupt.
> This imporves bandwidth by 30% under some workflows.
>
> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> ---
>
> Rusty, Dave, this patch depends on the patch
> "virtio: put last seen used index into ring itself"
> which is currently destined at Rusty's tree.
> Rusty, if you are taking that one for 2.6.35, please
> take this one as well.
> Dave, any objections?
>    

I object: I think the index should have its own cacheline, and that it 
should be documented before merging.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

