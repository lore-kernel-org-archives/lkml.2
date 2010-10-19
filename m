Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab0JSEKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:10:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab0JSEKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 00:10:21 -0400
Subject: Re: linux-next: build failure after merge of the security-testing
 tree
From: Eric Paris <eparis@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Moore <paul.moore@hp.com>,
        Patrick McHardy <kaber@trash.net>
In-Reply-To: <20101019145747.f828be03.sfr@canb.auug.org.au>
References: <20101019145747.f828be03.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 00:09:06 -0400
Message-ID: <1287461346.2530.128.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 14:57 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the security-testing tree, today's linux-next build (powerpc_ppc64_defconfig)
> failed like this:
> 
> net/netfilter/nf_conntrack_netlink.c: In function 'ctnetlink_conntrack_event':
> net/netfilter/nf_conntrack_netlink.c:585: error: 'struct nf_conn' has no member named 'secmark'
> 
> Caused by commit fd0194de4cf2e64514aec35f40de458fca766656 ("conntrack:
> export lsm context rather than internal secid via netlink").  This build
> has CONFIG_NF_CONNTRACK_SECMARK not set ...
> 
> If you change a dependency on a CONFIG option, it is always worth build
> testing with and without the option set.
> 
> I have used the security-testing tree from next-20101018 for today.

Ohhh, poop.  I didn't think I changed any config options but I see it
now.  Will fix by tomorrow.  Sorry and thanks for catching it.

-Eric

