Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab0LMUGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 15:06:48 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41022 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab0LMUGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 15:06:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=wTQJLnKZBotIvnvMsIdv0bXdZQxuVYky1kxkLnD33RhPvbOeJWv1CxitkdNlvAPZ/S
         nxBvT1hsa7TWCB+BdR2JyWQieFFDrU6xXstHvyTIh11NPssgOieEekYsz8lK9oYFBm8X
         akTnSc/3LPWhnwiXVQ6RWw8bXpOfUxTMO1UFg=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH v4 4/7] Reclaim invalidated page ASAP
In-Reply-To: <20101213153105.GA2344@barrios-desktop>
References: <cover.1291568905.git.minchan.kim@gmail.com> <0724024711222476a0c8deadb5b366265b8e5824.1291568905.git.minchan.kim@gmail.com> <20101208170504.1750.A69D9226@jp.fujitsu.com> <AANLkTikG1EAMm8yPvBVUXjFz1Bu9m+vfwH3TRPDzS9mq@mail.gmail.com> <87oc8wa063.fsf@gmail.com> <AANLkTin642NFLMubtCQhSVUNLzfdk5ajz-RWe2zT+Lw6@mail.gmail.com> <20101213153105.GA2344@barrios-desktop>
User-Agent: Notmuch/0.5-17-g2d1420b (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Mon, 13 Dec 2010 15:06:38 -0500
Message-ID: <87lj3t30a9.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 00:31:05 +0900, Minchan Kim <minchan.kim@gmail.com> wrote:
> In summary, my patch enhances a littie bit about elapsed time in
> memory pressure environment and enhance reclaim effectivness(reclaim/reclaim)
> with x2. It means reclaim latency is short and doesn't evict working set
> pages due to invalidated pages.
> 
Thank you very much for this testing! I'm very sorry I've been unable to
contribute more recently. My last exam is on Wednesday and besides some
grading that is the end of the semester.  Is there anything you would
like me to do? Perhaps reproducing these results on my setup would be
useful?

> Look at reclaim effectivness. Patched rsync enhances x2 about reclaim
> effectiveness and compared to mmotm-12-03, mmotm-12-03-fadvise enhances
> 3 minute about elapsed time in stress environment. 
> I think it's due to reduce scanning, reclaim overhead.
> 
Good good. This looks quite promising.

> In no-stress enviroment, fadivse makes program little bit slow.
> I think because there are many pgfault. I don't know why it happens.
> Could you guess why it happens?
> 
Hmm, nothing comes to mind. As I've said in the past, rsync should
require each page only once. Perhaps perf might offer some insight into
where this time is being spent?

- Ben
