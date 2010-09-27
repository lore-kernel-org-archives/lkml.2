Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab0I0Qyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:54:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21102 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab0I0Qyo (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 27 Sep 2010 12:54:44 -0400
Date: Mon, 27 Sep 2010 12:53:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Ingo Molnar <mingo@elte.hu>,
        Andre Goddard Rosa <andre.goddard@gmail.com>
Subject: Re: [PATCH 6/9] swiotlb: Declare swiotlb_init_with_default_size()
Message-ID: <20100927165340.GA5644@dumpdata.com>
References: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
 <1285282051-24907-1-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285282051-24907-1-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 03:47:30PM -0700, David Daney wrote:
> It comes from swiotlb.c and must be called by external code, so declare it.
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Andre Goddard Rosa <andre.goddard@gmail.com>
> ---
>  include/linux/swiotlb.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index 8c0e349..dba51fe 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -23,6 +23,7 @@ extern int swiotlb_force;
>  #define IO_TLB_SHIFT 11
>  
>  extern void swiotlb_init(int verbose);
> +extern void swiotlb_init_with_default_size(size_t, int);
>  extern void swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);

Just use the swiotlb_init_with_tbl. If you need an example of how it is utilized, take
a look at how swiotlb-xen.c does it.
