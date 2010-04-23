Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab0DWSvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 14:51:19 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:54380 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751236Ab0DWSvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 14:51:18 -0400
X-Greylist: delayed 1523 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Apr 2010 14:51:17 EDT
Date: Fri, 23 Apr 2010 22:26:19 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Richard =?utf-8?Q?R=C3=B6jfors?= <richard.rojfors@pelagicore.com>
Cc: David Vrabel <david.vrabel@csr.com>, Pierre Ossman <pierre@ossman.eu>,
       Ben Dooks <ben@simtec.co.uk>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] sdhci-pltfm: Add kernel-doc for struct sdhci_pltfm_data
Message-ID: <20100423182619.GA8743@oksana.dev.rtsoft.ru>
References: <20100316183400.GA24191@oksana.dev.rtsoft.ru>
 <20100316183429.GB25670@oksana.dev.rtsoft.ru>
 <4BA0732B.7040007@pelagicore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BA0732B.7040007@pelagicore.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Suggested-by: Richard Röjfors <richard.rojfors@pelagicore.com>
Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---

On Wed, Mar 17, 2010 at 07:14:03AM +0100, Richard Röjfors wrote:
> On 3/16/10 7:34 PM, Anton Vorontsov wrote:
> > This includes platform ops, quirks and (de)initialization callbacks.
> 
> Good idea, just a doc comment below.
[....]
> > +struct sdhci_pltfm_data {
> > +	struct sdhci_ops *ops;
> > +	unsigned int quirks;
> > +	int (*init)(struct sdhci_host *host);
> > +	void (*exit)(struct sdhci_host *host);
> > +};
> 
> I would like to see this struct kernel-doc:ed.

Done, thanks!

Andrew,

Please fold this patch into
sdhci-pltfm-implement-platform-data-passing.patch

Thanks,

 include/linux/sdhci-pltfm.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/sdhci-pltfm.h b/include/linux/sdhci-pltfm.h
index 0aaa334..0239bd7 100644
--- a/include/linux/sdhci-pltfm.h
+++ b/include/linux/sdhci-pltfm.h
@@ -17,6 +17,14 @@
 struct sdhci_ops;
 struct sdhci_host;
 
+/**
+ * struct sdhci_pltfm_data - SDHCI platform-specific information & hooks
+ * @ops: optional pointer to the platform-provided SDHCI ops
+ * @quirks: optional SDHCI quirks
+ * @init: optional hook that is called during device probe, before the
+ *        driver tries to access any SDHCI registers
+ * @exit: optional hook that is called during device removal
+ */
 struct sdhci_pltfm_data {
 	struct sdhci_ops *ops;
 	unsigned int quirks;
-- 
1.7.0.5

