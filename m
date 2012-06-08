Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900Ab2FHDRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 23:17:34 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43696 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab2FHDRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 23:17:33 -0400
Message-ID: <4FD16EC8.60502@gmail.com>
Date: Thu, 07 Jun 2012 23:17:28 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 1/5] vmstat: Implement refresh_vm_stats()
References: <20120601122118.GA6128@lizard> <1338553446-22292-1-git-send-email-anton.vorontsov@linaro.org>
In-Reply-To: <1338553446-22292-1-git-send-email-anton.vorontsov@linaro.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/1/12 8:24 AM), Anton Vorontsov wrote:
> This function forcibly flushes per-cpu vmstat diff counters to the
> global counters.
> 
> Note that we don't try to flush percpu pagesets, the pcp will be
> still flushed once per 3 seconds.
> 
> Signed-off-by: Anton Vorontsov<anton.vorontsov@linaro.org>

No.

This is insane. Your patch improved vmevent accuracy a _bit_. But instead of,
decrease a performance of large systems. That's no good deal. 99% user never
uses vmevent.

MOREOVER, this patch don't solve vmevent accuracy issue AT ALL. because of,
a second is enough big to make large inaccuracy. Modern cpus are fast. Guys,
the fact is, user land monitor can't use implicit batch likes vmstat. That's
a reason why perf don't use vmstat. I suggest you see perf APIs. It may bring
you good inspiration.

