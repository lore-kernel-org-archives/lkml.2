Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0LORBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:01:32 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:28696 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752241Ab0LORBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:01:31 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: YYSSxG4VM1klDJ.FKnm7tOMmskfHOYLraION5RBZ40_O2D7
 ZQ5zskn.KSoyJtws6h5W2utoHetVKbJM8_BL5RxB_8GmBtDzQsUz14hkkQFW
 HSuyz8UPPgvAwjKc_LfFYVCvWNhE.fTi5m2ScyhperA0KklW5KgeHadO8663
 ZFOdsX7Ze7Hsnm2QY4OHwnGwlxJSEnx2cPY5hMMXD9tJK6QUj.ShA2k6lChj
 m0KNi3UZA.ZadCDGiuS7CII2paLKnyOm5WnEtQrU.IZes2UITlyxIb4HnM9F
 wUX6HcT4R4a1BcyvQeOG3biUNrH.PjtecP65j2dBfywc.Hts-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 15 Dec 2010 11:01:27 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 4/5] vmstat: User per cpu atomics to avoid
 interrupt disable / enable
In-Reply-To: <4D08F0A2.9010301@kernel.org>
Message-ID: <alpine.DEB.2.00.1012151056280.13049@router.home>
References: <20101214162842.542421046@linux.com> <20101214162854.811759020@linux.com> <4D08F0A2.9010301@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Tejun Heo wrote:

> +		/*
> +		 * The fetching of the stat_threshold is racy. We may apply
> +		 * a counter threshold to the wrong the cpu if we get
> +		 * rescheduled while executing here. However, the following
> +		 * will apply the threshold again and therefore bring the
> +		 * counter under the threshold.
> +		 */
>
> What does "the following" mean here?  Later executions of the
> function?  It seems like the counter can go out of the threshold at
> least temporarily, which probably is okay but I think the comment can
> be improved a bit.

I meant later execution of the function. I will fix the comment.

Subject: vmstat comment fix

Clarify comments for the threshold a bit.

Signed-off-by: Christoh Lameter <cl@linux.com>

---
 mm/vmstat.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2010-12-15 10:57:44.000000000 -0600
+++ linux-2.6/mm/vmstat.c	2010-12-15 10:58:46.000000000 -0600
@@ -277,9 +277,12 @@ static inline void mod_state(struct zone
 		/*
 		 * The fetching of the stat_threshold is racy. We may apply
 		 * a counter threshold to the wrong the cpu if we get
-		 * rescheduled while executing here. However, the following
-		 * will apply the threshold again and therefore bring the
-		 * counter under the threshold.
+		 * rescheduled while executing here. However, the next
+		 * counter update will apply the threshold again and
+		 * therefore bring the counter under the threshold again.
+		 *
+		 * Most of the time the thresholds are the same anyways
+		 * for all cpus in a zone.
 		 */
 		t = this_cpu_read(pcp->stat_threshold);

