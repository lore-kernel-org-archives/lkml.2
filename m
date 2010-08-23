Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab0HWQlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:41:55 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:27620 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751749Ab0HWQlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:41:53 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: FfX6I_IVM1kG7nnm3e_QSqTDa7_H0XYt.VCgwu7aJGjrBFU
 lrCH2J6aotr9ftt6I9KBut5zqhwH9zscjJnDHBs4Bm_kTeHdaVwSn1vQ848W
 dDmS8YhGXhLNm.Q6H3uqu0GvWSl0Vb6vynp6OcFLX_eHzJFISmCkOjR1SrvK
 zodWhXKfDs3wVZZhdIc04yxubSz6Ci.ty0Ccc2eudZ_5PoeoTI98guiU9sND
 FDPpv.1aOoCUvou6W__8Gq_seFdFW
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 23 Aug 2010 11:41:49 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] compaction: fix COMPACTPAGEFAILED counting
In-Reply-To: <1282580114-2136-1-git-send-email-minchan.kim@gmail.com>
Message-ID: <alpine.DEB.2.00.1008231140320.9496@router.home>
References: <1282580114-2136-1-git-send-email-minchan.kim@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Minchan Kim wrote

> This patch introude new argument 'cleanup' to migrate_pages.
> Only if we set 1 to 'cleanup', migrate_page will clean up the lists.
> Otherwise, caller need to clean up the lists so it has a chance to postprocess
> the pages.

Could we simply make migrate_pages simply not do any cleanup?
Caller has to call putback_lru_pages()?

