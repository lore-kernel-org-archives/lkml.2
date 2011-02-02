Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1BBH4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 02:56:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:47433 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab1BBH4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 02:56:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,413,1291622400"; 
   d="scan'208";a="383062217"
Subject: Re: [PATCH] [128/139] mac80211: fix mesh forwarding
From: Johannes Berg <johannes.berg@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "javier@cozybit.com" <javier@cozybit.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <20110202004527.B26AE3E09BD@tassilo.jf.intel.com>
References: <20110201443.618138584@firstfloor.org>
	 <20110202004527.B26AE3E09BD@tassilo.jf.intel.com>
Date: Wed, 02 Feb 2011 08:56:14 +0100
Message-ID: <1296633374.3624.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p127uUkj014863

On Wed, 2011-02-02 at 00:45 +0000, Andi Kleen wrote:

> -			if (!fwd_skb && net_ratelimit())
> +			if (!fwd_skb && net_ratelimit()) {
>  				printk(KERN_DEBUG "%s: failed to clone mesh frame\n",
>  						   sdata->name);
> +				goto out;
> +			}

The net_ratelimit() here cause an obvious bug that I missed and a patch
for that was submitted later -- you may want to pick that one up and/or
fold it in (commit 919bbad580445801c22ef6ccbe624551fee652bd).

johannes

--------------------------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland 
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
