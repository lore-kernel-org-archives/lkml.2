Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0LHNB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 08:01:29 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44082 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab0LHNB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 08:01:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=ptArj7pqiG2cYtiNlE8xB02YLwKma2dOgIRDx0EDAT/xGIM6LXFZOx9DnoK8vAXd7U
         cP+yHMt7C0+YA1Gz6D84xDaf8ZXCDRsdFTTjovv1THHqD1qsAyQBQF1Yb42ln/5Yfp3W
         4dGo+p8qFejRrhnSjSNaCUi//s3bR0TkUy6h0=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH v4 4/7] Reclaim invalidated page ASAP
In-Reply-To: <AANLkTikG1EAMm8yPvBVUXjFz1Bu9m+vfwH3TRPDzS9mq@mail.gmail.com>
References: <cover.1291568905.git.minchan.kim@gmail.com> <0724024711222476a0c8deadb5b366265b8e5824.1291568905.git.minchan.kim@gmail.com> <20101208170504.1750.A69D9226@jp.fujitsu.com> <AANLkTikG1EAMm8yPvBVUXjFz1Bu9m+vfwH3TRPDzS9mq@mail.gmail.com>
User-Agent: Notmuch/0.5-17-g2d1420b (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Wed, 08 Dec 2010 08:01:24 -0500
Message-ID: <87oc8wa063.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Make sense to me. If Ben is busy, I will measure it and send the result.

I've done measurements on the patched kernel. All that remains is to do
measurements on the baseline unpached case. To summarize the results
thusfar,

Times:
=======
                       user    sys     %cpu    inputs           outputs
Patched, drop          142     64      46      13557744         14052744
Patched, nodrop        55      57      33      13557936         13556680

vmstat:
========
                        free_pages      inact_anon      act_anon        inact_file      act_file        dirtied      written  reclaim
Patched, drop, pre      306043          37541           185463          276266          153955          3689674      3604959  1550641
Patched, drop, post     13233           38462           175252          536346          178792          5527564      5371563  3169155

Patched, nodrop, pre    475211          38602           175242          81979           178820          5527592      5371554  3169155
Patched, nodrop, post   7697            38959           176986          547984          180855          7324836      7132158  3169155

Altogether, it seems that something is horribly wrong, most likely with
my test (or rsync patch). I'll do the baseline benchmarks today.

Thoughts?

Thanks,

- Ben

