Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab0FGHvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 03:51:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56865 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab0FGHvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 03:51:18 -0400
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mst@redhat.com, mingo@elte.hu,
       davem@davemloft.net, herbert@gondor.hengli.com.au,
       jdike@linux.intel.com
Subject: Re: [RFC PATCH v7 01/19] Add a new structure for skb buffer from external.
From: Andi Kleen <andi@firstfloor.org>
References: <1275732899-5423-1-git-send-email-xiaohui.xin@intel.com>
	<20100606161348.427822fb@nehalam>
Date: Mon, 07 Jun 2010 09:51:11 +0200
In-Reply-To: <20100606161348.427822fb@nehalam> (Stephen Hemminger's message of "Sun\, 6 Jun 2010 16\:13\:48 -0700")
Message-ID: <87pr03gu1c.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemminger@vyatta.com> writes:

> Still not sure this is a good idea for a couple of reasons:
>
> 1. We already have lots of special cases with skb's (frags and fraglist),
>    and skb's travel through a lot of different parts of the kernel.  So any
>    new change like this creates lots of exposed points for new bugs. Look
>    at cases like MD5 TCP and netfilter, and forwarding these SKB's to ipsec
>    and ppp and ...
>
> 2. SKB's can have infinite lifetime in the kernel. If these buffers come from
>    a fixed size pool in an external device, they can easily all get tied up
>    if you have a slow listener. What happens then?

3. If they come from an internal pool what happens when the kernel runs 
low on memory? How is that pool balanced against other kernel
memory users?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
