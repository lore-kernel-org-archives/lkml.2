Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1LSSm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 13:42:27 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:2828 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab1LSSmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 13:42:24 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4EEF858C.1070600@freescale.com>
Date: Mon, 19 Dec 2011 12:42:20 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: <Artem.Bityutskiy@nokia.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <shuo.liu@freescale.com>,
        <linux-mtd@lists.infradead.org>, <akpm@linux-foundation.org>,
        <dwmw2@infradead.org>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com> <1322973098-2528-3-git-send-email-shuo.liu@freescale.com> <4EDEAEB9.6020703@freescale.com> <1323724195.2297.11.camel@koala> <4EE66EFE.1050608@freescale.com> <1323724784.2297.20.camel@koala> <4EE6725C.3050706@freescale.com> <1324132520.4240.26.camel@sauron.fi.intel.com> <4EEF849B.7030804@freescale.com>
In-Reply-To: <4EEF849B.7030804@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 12:38 PM, Scott Wood wrote:
> On 12/17/2011 08:35 AM, Artem Bityutskiy wrote:
>> It looks like currently you can re-define chip->read_page, so I guess
>> you should rework MTD and make chip->write_page re-definable?
> 
> Unless something has changed very recently, there is no chip->read_page
> or chip->write_page.  There is chip->ecc.read_page and
> chip->ecc.write_page, but they are too low-level.  What we'd need to
> replace is a portion of nand_do_read_ops()/nand_do_write_ops().

Sorry, chip->write_page does exist -- it's chip->read_page that would
need to be made similarly redefinable.

-Scott


