Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab2DNMGp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 08:06:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40121 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab2DNMGn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 08:06:43 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1204141439440.1680@ja.ssi.bg>
References: <1334409722-26315-1-git-send-email-levinsasha928@gmail.com> <alpine.LFD.2.00.1204141439440.1680@ja.ssi.bg>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sat, 14 Apr 2012 14:06:22 +0200
Message-ID: <CA+1xoqe0q=XH7mO6=qZKPxqZK8LU2Kk5BjmfLeQ9LUD1Ku65YA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] netfilter: ipvs: Verify that IP_VS protocol has
 been registered
To: Julian Anastasov <ja@ssi.bg>
Cc: wensong@linux-vs.org, horms@verge.net.au, kaber@trash.net,
        davem@davemloft.net, davej@redhat.com, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 1:53 PM, Julian Anastasov <ja@ssi.bg> wrote:
>        Ops. It seems now we expose old problem when
> no protocol is configured. As this change probably will
> go to stable kernels, lets make it correct. Can you
> remove the defines around register_ip_vs_proto_netns, so
> that it is always compiled. One that wants to save
> memory will not disable all protocols. See commit
> 091bb34c143674d37a59b2d4857534f7106c5d7d for reference.

Oh, so it wasn't getting built right now at all if we didn't select
any protocols.

How about moving those defines down to our loop as well? this way
everything will behave exactly like it did before.
