Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab1DLGSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 02:18:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40835 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab1DLGSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 02:18:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fi8IDtC3cFAEXocFlTrBb4wXx6hh7Ya1e2+YNY9v0Akqqnbu5QxdptApLjBMsTRfhS
         vqkIS6tP5wKNiy5Pjh27zRQm3uV5dk1bnKDRnknWlpugKkYT3B2DRE1SY5M/8YWl5zqN
         yoj4BbrtWKibEYNOW5t/0odO2seExGV3Qe7h0=
MIME-Version: 1.0
In-Reply-To: <20110411170033.0356.A69D9226@jp.fujitsu.com>
References: <20110411165957.0352.A69D9226@jp.fujitsu.com>
	<20110411170033.0356.A69D9226@jp.fujitsu.com>
Date: Tue, 12 Apr 2011 15:18:35 +0900
Message-ID: <BANLkTimPB5e_A3AxS_7kuJmqciRciCm2Sw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm, mem-hotplug: fix section mismatch.
 setup_per_zone_inactive_ratio() should be __meminit.
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasunori Goto <y-goto@jp.fujitsu.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 5:00 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Commit bce7394a3e (page-allocator: reset wmark_min and inactive ratio of
> zone when hotplug happens) introduced invalid section references.
> Now, setup_per_zone_inactive_ratio() is marked __init and then it can't
> be referenced from memory hotplug code.
>
> Then, this patch marks it as __meminit and also marks caller as __ref.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Just a nitpick.

As below comment of __ref said, It would be better to add _why_ such
as memory_hotplug.c.

"so optimally document why the __ref is needed and why it's OK"

Anyway,
Thanks, KOSAKI.

-- 
Kind regards,
Minchan Kim
