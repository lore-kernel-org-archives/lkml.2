Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386Ab0I0Ws3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:48:29 -0400
Received: from mail.us.es ([193.147.175.20]:33717 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760287Ab0I0Ws1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:48:27 -0400
Message-ID: <4CA11F36.2090705@netfilter.org>
Date: Tue, 28 Sep 2010 00:48:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100619 Icedove/3.0.5
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Paul Moore <paul.moore@hp.com>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        netfilter-devel@vger.kernel.org, sds@tycho.nsa.gov, jengelh@medozas.de,
        casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
        netfilter@vger.kernel.org, mr.dash.four@googlemail.com
Subject: Re: [PATCH 3/6] secmark: export binary yes/no rather than kernel
 internal secid
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>	 <20100924204531.28355.20320.stgit@paris.rdu.redhat.com>	 <alpine.LRH.2.00.1009271038280.25748@tundra.namei.org>	 <1285606896.2815.36.camel@localhost.localdomain>	 <1285612156.4935.16.camel@sifl> <1285615525.2815.76.camel@localhost.localdomain>
In-Reply-To: <1285615525.2815.76.camel@localhost.localdomain>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/09/10 21:25, Eric Paris wrote:
> I see it as having 3 options.  lets assume was have a packet with
> selinux sid=121 and selinux context=packet_t.  We can
> 
> 1) secmark=121 secctx=packet_t
> 	This continues to send secmark like we do and people might continue to
> be baffled by the 121.
> 
> 2) secmark=1 secctx=packet_t
> 	This sends a secmark field to userspace so if an application which
> reads this exists (I doubt such an application actually exists in in the
> real world) it will still get all of the information it got before but
> noone will be baffled by what the number means.  1/0 is pretty obvious.

In netlink, we can obsolete fields without breaking backward
compatibility. Applications parsing the /proc entry may break, but they
should use stable interfaces (like netlink) instead.

BTW, if we finally stop including CTA_SECMARK in netlink messages,
please add a small comment on the right of the definition in
nfnetlink_conntrack.h (something like /* obsolete */ or /* unused */).
Thanks!
