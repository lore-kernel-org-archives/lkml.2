Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab2HONjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:39:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab2HONjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:39:19 -0400
Message-ID: <502BA72B.6070205@redhat.com>
Date: Wed, 15 Aug 2012 21:42:03 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: jhs@mojatatu.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] act_mirred: do not drop packets when fails to mirror
 it
References: <20120815093756.22238.80872.stgit@amd-6168-8-1.englab.nay.redhat.com> <1345034141.20443.12.camel@mojatatu>
In-Reply-To: <1345034141.20443.12.camel@mojatatu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 08:35 PM, Jamal Hadi Salim wrote:
> On Wed, 2012-08-15 at 17:37 +0800, Jason Wang wrote:
>> We drop packet unconditionally when we fail to mirror it. This is not intended
>> in some cases.
> Hi Jason,
> Did you actually notice the behavior you described or were you going by
> the XXX comment I had in the code?
>
> cheers,
> jamal
Hi Jamal:

I met it actually through the following steps:

- start a kvm guest with tap and make it to be an interface of the bridge
- mirror the ingress traffic of the bridge to the tap
- terminate the qemu process, the tap device is then removed
- all packet goes to bridge would be dropped, so the network of guests 
in the same bridge would be broken

It's hard for the management to forcast the termination of the porcess 
and clean the mirroring before. The realistic way is to remove the 
mirroring after the termination of the process. So, if we drop the 
packets when the mirred device (tap) is removed, in the gap between the 
qemu termitnaion and disabling mirroring, the bridge ( and other VMs 
using the it) would not recevie any packet.

>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

