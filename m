Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab0KVQur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:50:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:23129 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab0KVQup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:50:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,237,1288594800"; 
   d="scan'208";a="351811464"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Dan Carpenter <error27@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Mon, 22 Nov 2010 16:49:45 +0000
Subject: RE: [patch v2] dca: remove unneeded NULL check
Thread-Topic: [patch v2] dca: remove unneeded NULL check
Thread-Index: AcuI3qBHFdb6n805RJahaRancTn81gBhfGIg
Message-ID: <129600E5E5FB004392DDC3FB599660D70104DAF162@irsmsx504.ger.corp.intel.com>
References: <20101117051032.GC31724@bicker>
 <20101119145937.60c5f688.akpm@linux-foundation.org>
 <20101120181008.GB1522@bicker>
In-Reply-To: <20101120181008.GB1522@bicker>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote:
> The return here doesn't release the locks or re-enable IRQs.  But as
> Andrew Morton points out, domain is never NULL.  list_first_entry()
> essentially never returns NULL and also we already verified that the
> list is not empty.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c index
> b98c676..c461eda 100644
> --- a/drivers/dca/dca-core.c
> +++ b/drivers/dca/dca-core.c
> @@ -110,8 +110,6 @@ static void unregister_dca_providers(void)
> 
>  	/* at this point only one domain in the list is expected */
>  	domain = list_first_entry(&dca_domains, struct dca_domain, node);
> -	if (!domain)
> -		return;
> 
>  	list_for_each_entry_safe(dca, _dca, &domain->dca_providers, node) {
>  		list_del(&dca->node);

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
