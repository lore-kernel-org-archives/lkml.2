Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab1GRO4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 10:56:35 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:30971 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751201Ab1GRO4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 10:56:34 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: _d3y2UMVM1lQIRi9PPvZQTnaxTX01Ln7xgBctT_2MhU0vRt
 n77KBMgcprJY6jxZWDPboLkkfVcULpj57WbxVzhyms7VGceSZRHDe3Hol8Lu
 Idz6tNTkmC4J8M3zcj6qiKTyNdvw4hVycNhjFP4KBEnLr0sQQfccNj.sqrgZ
 FmvwsvEViaJ856Jx9Iq9HtdYe295pJsX7lF46M2aTkuR31kI48aBbwXejMdi
 x_KRi2eWpDfcV4TPXNHTk_qDk7hJxfBMOtHm_pufGKzzcKyc2pG4_Yv_R0Wg
 Jti1g2QFenRCAg1sQtjM1zlCSVjV6sufe6EePBwZl9ObV9f8EydtB5eptSHy
 mC.RzT0YpGsdvU6_uS2_AIZQf
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 18 Jul 2011 09:56:31 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: page allocator: Initialise ZLC for first zone
 eligible for zone_reclaim
In-Reply-To: <1310742540-22780-2-git-send-email-mgorman@suse.de>
Message-ID: <alpine.DEB.2.00.1107180951390.30392@router.home>
References: <1310742540-22780-1-git-send-email-mgorman@suse.de> <1310742540-22780-2-git-send-email-mgorman@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jul 2011, Mel Gorman wrote:

> Currently the zonelist cache is setup only after the first zone has
> been considered and zone_reclaim() has been called. The objective was
> to avoid a costly setup but zone_reclaim is itself quite expensive. If
> it is failing regularly such as the first eligible zone having mostly
> mapped pages, the cost in scanning and allocation stalls is far higher
> than the ZLC initialisation step.

Would it not be easier to set zlc_active and allowednodes based on the
zone having an active ZLC at the start of get_pages()?

Buffered_rmqueue is handling the situation of a zone with an ZLC in a
weird way right now since it ignores the (potentially existing) ZLC
for the first pass. zlc_setup() does a lot of things. So that is because
there is a performance benefit?


