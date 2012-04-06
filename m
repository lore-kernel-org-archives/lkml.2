Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab2DFI7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 04:59:37 -0400
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:44814 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2DFI7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 04:59:35 -0400
MIME-Version: 1.0
X-Mailer: AfterLogic WebMail PHP
X-Originating-IP: 172.24.1.200
X-Priority: 3 (Normal)
Message-ID: <6dfqp4f.85748eeb029b04c66ac5e143b62a5455@obelix.schillstrom.com>
From: "Hans Schillstrom" <hans@schillstrom.com>
To: "Simon Horman" <horms@verge.net.au>
Cc: "Sasha Levin" <levinsasha928@gmail.com>, wensong@linux-vs.org, ja@ssi.bg,
        kaber@trash.net, davem@davemloft.net, davej@redhat.com,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re[2]:  [PATCH] netfilter: ipvs: Verify that IP_VS protocol 
	has been registered
Date: Fri, 6 Apr 2012 10:59:23 +0200 (CEST)
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Simon

>---- Original Message ----
>From: Simon Horman <horms@verge.net.au>
>To: "Sasha Levin" <levinsasha928@gmail.com>
>Cc: wensong@linux-vs.org, ja@ssi.bg, kaber@trash.net, davem@davemloft.net, davej@redhat.com, netdev@vger.kernel.org, lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
>Sent: Fri, Apr 6, 2012, 1:19 AM
>Subject: Re: [PATCH] netfilter: ipvs: Verify that IP_VS protocol has been registered
>
>On Thu, Apr 05, 2012 at 07:24:33PM -0400, Sasha Levin wrote:
>> The registration of a protocol might fail, there were no checks
>> and all registrations were assumed to be correct. This lead to
>> NULL ptr dereferences when apps tried registering.
>
>Thanks, I will queue up this fix.
>
>Do you have a real-world example of this failing, if so it
>might be worth pushing your change into stable.

I don't think this is a big thing, the only thing that can cause it is out of memory,
and that will cause a "kernel death" anyway :-(

here is the code :

register_ip_vs_proto_netns(struct net *net, struct ip_vs_protocol *pp)
{
...
	struct ip_vs_proto_data *pd =
			kzalloc(sizeof(struct ip_vs_proto_data), GFP_ATOMIC);

	if (!pd)
		return -ENOMEM;


>--
>To unsubscribe from this list: send the line "unsubscribe lvs-devel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

