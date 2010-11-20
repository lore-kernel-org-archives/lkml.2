Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab0KTW7a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 17:59:30 -0500
Received: from nm13.bullet.mail.sp2.yahoo.com ([98.139.91.83]:39626 "HELO
	nm13.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755142Ab0KTW73 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 17:59:29 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 885228.10817.bm@omp1017.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=14F/0ySZ0R6Al3OR+Ik9uGSqLObq0dFe70IBP3Bd/nnDNfP9OHOyYoqbq/149Vb4E+sBrVtbdngG9avCuRD0OBJCM9OzSv3ftyhTpL+qmNOAGvuBhHJ0oEw4Xh3gxM0iu79ckZtLdOVixldtr6If7B2A8E92iD2XFCreNRrrlZg=;
Message-ID: <616676.83025.qm@web180301.mail.gq1.yahoo.com>
X-YMail-OSG: 16aZf_oVM1nXcEkx6hGP4CyscRcfWWKK_y97cfWtmx.7a0p
 9Z0_uLpifWbwueeTuiDjju.AaBgl7K2o1kFoXMtm26hN_ldjmBGRzi.En0NZ
 jBB6BlKL_.iNsbt4fQxM8I.WJ8Uy_OdDGeNWeqHMfDSCNvhf5Z_UA59r2dFG
 OUAvd26Mv_.d4GV164F4lK_OZpzMkt82inXs3BvKpWwhjy2zdwnhY008nI0j
 p.L7cDebmaM0dtCyoLvmPcgO7Y5_2uvCCISwg3ee2rLHR1PLzz839HocXNvx
 f8V0WGnJNwJVtOIRrlxkUfZ98Ln4eN.94SJzvloSF.2Cjwy3z2VlAQF0E17j
 A1c8vi1WVp0lOzLq2P7U3KJuwjtMcUgFlt7ec9PypfC1Rq3WAzH12IQ--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Sat, 20 Nov 2010 14:59:28 -0800 (PST)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 6/6] atmel_spi: fix warning In function 'atmel_spi_dma_map_xfer'
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net
In-Reply-To: <20101120214820.GG8942@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sat, 11/20/10, Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

> > +        void
> *nonconst_tx = (void *)xfer->tx_buf; /* shut up gcc */

Reads like a bad patch to me. Fix the bug,
don't just silence GCC.  Or at least use
a better comment mentioning a constness
cast problems).

- Dave

