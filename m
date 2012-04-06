Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2DFJHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 05:07:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37339 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab2DFJHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 05:07:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120405231942.GB7715@verge.net.au>
References: <1333668273-8873-1-git-send-email-levinsasha928@gmail.com> <20120405231942.GB7715@verge.net.au>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 6 Apr 2012 11:07:21 +0200
Message-ID: <CA+1xoqcS2+F+Nz_akXNQ7k+nuHkJjXYG6d=faMZ6xx1CW=RtPA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: ipvs: Verify that IP_VS protocol has been registered
To: Simon Horman <horms@verge.net.au>
Cc: wensong@linux-vs.org, ja@ssi.bg, kaber@trash.net, davem@davemloft.net,
        davej@redhat.com, netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 1:19 AM, Simon Horman <horms@verge.net.au> wrote:
> On Thu, Apr 05, 2012 at 07:24:33PM -0400, Sasha Levin wrote:
>> The registration of a protocol might fail, there were no checks
>> and all registrations were assumed to be correct. This lead to
>> NULL ptr dereferences when apps tried registering.
>
> Thanks, I will queue up this fix.
>
> Do you have a real-world example of this failing, if so it
> might be worth pushing your change into stable.

The scenario is a failed allocation in register_ip_vs_proto_netns(),
which can happen in real world cases as well.
