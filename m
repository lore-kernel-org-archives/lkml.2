Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab2FEOhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 10:37:08 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:22502 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756337Ab2FEOhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 10:37:05 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: phkCf0YVM1nzDCw67I2R8M1egUfVZOVa0nd9yI.G32ct0_0
 3F4Hv5_UET_nyRftavEcPVfWV4pF_K9qrg5t2dBgi9GPUMTHn2Z_6JPeProT
 Xd9EXNBSH.Skp8DGdakVY7_MikXxgG2.fa4h6lgbj0TyUBO3PYL5bZYw60tD
 0egTNlEm06SZjFFpjVXSU1_b7hIPE5PB9AMTFGfP1JxWQsgniE369q1ohbp5
 8xvVogrzqcXZcOpZhTKDFVGrCAiUel49DpNlVSwOQ8AGu6WO41TLWXj6Kfr1
 vc9rhPD0aVT1szsgyTYtdHltCFyhWTcZc_6PrmOimnJcQWwj4jRO9WSqi.2C
 NxB4O5WoyfOv4HDpp58EnZJimj_lNZWsvD7x36n3_xM2Pd27052v.DMIbP7W
 RJFM7rdtRI1kK2xpgK_xsPIJaiPWOWgZW_1Pm
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 5 Jun 2012 09:36:57 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Anton Vorontsov <anton.vorontsov@linaro.org>
cc: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 3/5] vmevent: Refresh vmstats before sampling
In-Reply-To: <1338553446-22292-3-git-send-email-anton.vorontsov@linaro.org>
Message-ID: <alpine.DEB.2.00.1206050934330.26918@router.home>
References: <20120601122118.GA6128@lizard> <1338553446-22292-3-git-send-email-anton.vorontsov@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2012, Anton Vorontsov wrote:

> On SMP, kernel updates vmstats only once per second, which makes vmevent
> unusable. Let's fix it by updating vmstats before sampling.

Well this may increase your accuracy but there is no guarantee that an
update to vm counters will not happen immediately after you have refreshed
the counters for one processor or the other.

Also please consider the impact that a IPI broadcast will have on latency
of other processors and to the function that is currently executing.

We just went through a round of getting rid of IPI broadcast because they
create OS noise on processors.

