Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab2JBLER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:04:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab2JBLEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:04:14 -0400
Subject: Re: [PATCH 3/6] arch/powerpc/kvm/e500_tlb.c: fix error return code
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1344160356-387-4-git-send-email-Julia.Lawall@lip6.fr>
Date: Tue, 2 Oct 2012 13:04:03 +0200
Cc: kernel-janitors@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>
Content-Transfer-Encoding: 8BIT
Message-Id: <BF4777C1-E76A-4AEB-A87D-FC2CBB465F98@suse.de>
References: <1344160356-387-1-git-send-email-Julia.Lawall@lip6.fr> <1344160356-387-4-git-send-email-Julia.Lawall@lip6.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05.08.2012, at 11:52, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Convert a 0 error return code to a negative one, as returned elsewhere in the
> function.
> 
> A new label is also added to avoid freeing things that are known to not yet
> be allocated.
> 
> A simplified version of the semantic match that finds the first problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> identifier ret;
> expression e,e1,e2,e3,e4,x;
> @@
> 
> (
> if (\(ret != 0\|ret < 0\) || ...) { ... return ...; }
> |
> ret = 0
> )
> ... when != ret = e1
> *x = \(kmalloc\|kzalloc\|kcalloc\|devm_kzalloc\|ioremap\|ioremap_nocache\|devm_ioremap\|devm_ioremap_nocache\)(...);
> ... when != x = e2
>    when != ret = e3
> *if (x == NULL || ...)
> {
>  ... when != ret = e4
> *  return ret;
> }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Thanks, applied to kvm-ppc-next.


Alex

