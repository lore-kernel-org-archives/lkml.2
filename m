Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab1KKOqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 09:46:34 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:30144 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755912Ab1KKOqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 09:46:32 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WTM93cAVM1kNHyJZqwYFbByP8DFfvg3W0CDhkmQUl1G_MdQ
 iLObNOZX0d2ACfGhzbFFbgs5_0qqiDHsn4_hDkHGplheTj.7_IvKTfMn1RvG
 4npNFL9iDFxjeSbWBNqlDk1rlcuomVThgrewHzhh2C9ulglX.G6VTepJ46iT
 I6AtFvQjLEwlExbvT_G0HTs4GtYD9FJUiVVBM_eAZmehpTBzbvcjJS.UU4gZ
 1.jDlw0kub71TCx2yiHxxl4gXnCDIGdCMFvce.6uj.TvwbPtQS435ZHJmQ7m
 PbjD.w3MI7rQozTEdenbelsanD8jcH7KK8pnq8SyV4kYbI47fYzK8oWblEWh
 jUECSMsME61kZBUC6kjA.OZbHSHkW0D41ljEIQzCJNFGGQd7LM0fATm1HWoY
 1.owOKCvJ78lrp0K5Vsm6gw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 11 Nov 2011 08:46:29 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 4/4] slub: min order when corrupt_dbg
In-Reply-To: <1321014994-2426-4-git-send-email-sgruszka@redhat.com>
Message-ID: <alpine.DEB.2.00.1111110845260.3006@router.home>
References: <1321014994-2426-1-git-send-email-sgruszka@redhat.com> <1321014994-2426-4-git-send-email-sgruszka@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Nov 2011, Stanislaw Gruszka wrote:

> Disable slub debug facilities and allocate slabs at minimal order when
> corrupt_dbg > 0 to increase probability to catch random memory
> corruption by cpu exception.

Just setting slub_max_order to zero on boot has the same effect that all
of this here. Settug slub_max_order would only require a small hunk in
kmem_cache_init.

