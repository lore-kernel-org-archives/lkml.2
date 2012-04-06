Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2DFJWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 05:22:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59949 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab2DFJWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 05:22:34 -0400
MIME-Version: 1.0
In-Reply-To: <6dfqp4f.85748eeb029b04c66ac5e143b62a5455@obelix.schillstrom.com>
References: <6dfqp4f.85748eeb029b04c66ac5e143b62a5455@obelix.schillstrom.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 6 Apr 2012 11:22:13 +0200
Message-ID: <CA+1xoqe_VGuUaMCpWWz=gSBBmGu8cUha9qznzhy_jNCRknudBA@mail.gmail.com>
Subject: Re: Re[2]: [PATCH] netfilter: ipvs: Verify that IP_VS protocol has
 been registered
To: Hans Schillstrom <hans@schillstrom.com>
Cc: Simon Horman <horms@verge.net.au>, wensong@linux-vs.org, ja@ssi.bg,
        kaber@trash.net, davem@davemloft.net, davej@redhat.com,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 10:59 AM, Hans Schillstrom <hans@schillstrom.com> wrote:
> Hello Simon
>
>>---- Original Message ----
>>From: Simon Horman <horms@verge.net.au>
>>To: "Sasha Levin" <levinsasha928@gmail.com>
>>Cc: wensong@linux-vs.org, ja@ssi.bg, kaber@trash.net, davem@davemloft.net, davej@redhat.com, netdev@vger.kernel.org, lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
>>Sent: Fri, Apr 6, 2012, 1:19 AM
>>Subject: Re: [PATCH] netfilter: ipvs: Verify that IP_VS protocol has been registered
>>
>>On Thu, Apr 05, 2012 at 07:24:33PM -0400, Sasha Levin wrote:
>>> The registration of a protocol might fail, there were no checks
>>> and all registrations were assumed to be correct. This lead to
>>> NULL ptr dereferences when apps tried registering.
>>
>>Thanks, I will queue up this fix.
>>
>>Do you have a real-world example of this failing, if so it
>>might be worth pushing your change into stable.
>
> I don't think this is a big thing, the only thing that can cause it is out of memory,
> and that will cause a "kernel death" anyway :-(
>
> here is the code :
>
> register_ip_vs_proto_netns(struct net *net, struct ip_vs_protocol *pp)
> {
> ...
>        struct ip_vs_proto_data *pd =
>                        kzalloc(sizeof(struct ip_vs_proto_data), GFP_ATOMIC);
>
>        if (!pd)
>                return -ENOMEM;
>
>

Considering that the allocation gfp flag here is GFP_ATOMIC (why is it
GFP_ATOMIC btw?), it might fail for a variety of reasons which may
occur when the system is "healthy", for example - if it needs disk I/O
to allocate.

Either way, you shouldn't be dereferencing NULL ptrs even when the
system is really low on memory.
