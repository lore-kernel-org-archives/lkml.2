Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab2EVKNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:13:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900Ab2EVKNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:13:36 -0400
Message-ID: <4FBB66C6.2020701@redhat.com>
Date: Tue, 22 May 2012 18:13:26 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Shirley Ma <mashirle@us.ibm.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, davem@davemloft.net
Subject: Re: [V2 PATCH 9/9] vhost: zerocopy: poll vq in zerocopy callback
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>  <20120502034254.11782.27314.stgit@amd-6168-8-1.englab.nay.redhat.com>  <1337100630.8220.4.camel@oc3660625478.ibm.com> <4FB317C8.90002@redhat.com>  <1337181027.10741.13.camel@oc3660625478.ibm.com>  <20120516151444.GC9934@redhat.com>  <1337189525.10741.24.camel@oc3660625478.ibm.com>  <4FB4677A.8020402@redhat.com>  <1337268862.10741.58.camel@oc3660625478.ibm.com>  <4FB61D57.4030103@redhat.com>  <1337354974.12999.12.camel@oc3660625478.ibm.com>  <4FB9DB24.2040408@redhat.com>  <1337614972.12999.56.camel@oc3660625478.ibm.com> <1337616766.12999.81.camel@oc3660625478.ibm.com>
In-Reply-To: <1337616766.12999.81.camel@oc3660625478.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 12:12 AM, Shirley Ma wrote:
> Then it could be too early for vhost to notify guest anywhere in
> handle_tx for zerocopy. Then we might need to remove any notification in
> handle_tx for zerocopy to vhost zerocopy callback instead.
>
> Adding vhost_poll_queue in vhost zerocopy callback unconditionally would
> consume unnecessary cpu.
>
> We need to think about a better solution here.

A possible idea is only call vhost_poll_queue only when the packet of 
used_event were sent: if there's no out-of-order completion vhost could 
signal the guest; if there is, let the pending packets before used_event 
call vhost_poll_queue.
> Thanks
> Shirley

