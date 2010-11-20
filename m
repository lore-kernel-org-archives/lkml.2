Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0KTSNZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 13:13:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46570 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab0KTSNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 13:13:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=qDmvsRb2CGaqibNsSuZz2Ozxyu/+q5HUFcDZiYjBJzqqJ/yGya3akS630/oQIxYW1X
         dXNhqwo1lwfcivzF6ygEi8jWzZoL9Dup4W35xA1yI5P6WTD542wiahd5mRRa88p5Dh3g
         2l1ZEe+t+o25TN7De6d/AzsITeKWiNk4ihkzE=
Date: Sat, 20 Nov 2010 21:10:16 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch v2] dca: remove unneeded NULL check
Message-ID: <20101120181008.GB1522@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Maciej Sosnowski <maciej.sosnowski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20101117051032.GC31724@bicker>
 <20101119145937.60c5f688.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119145937.60c5f688.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return here doesn't release the locks or re-enable IRQs.  But as
Andrew Morton points out, domain is never NULL.  list_first_entry() 
essentially never returns NULL and also we already verified that the
list is not empty. 

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
index b98c676..c461eda 100644
--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -110,8 +110,6 @@ static void unregister_dca_providers(void)
 
 	/* at this point only one domain in the list is expected */
 	domain = list_first_entry(&dca_domains, struct dca_domain, node);
-	if (!domain)
-		return;
 
 	list_for_each_entry_safe(dca, _dca, &domain->dca_providers, node) {
 		list_del(&dca->node);
