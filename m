Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab2A3TWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 14:22:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab2A3TWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 14:22:47 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] pagemap: avoid splitting thp when reading /proc/pid/pagemap
Date: Mon, 30 Jan 2012 14:23:52 -0500
Message-Id: <1327951432-29110-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <CAJd=RBDLEWuAKmRcaUJXuz=h9_3kaexbdGyqv7KXn+dmMeUvCQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 09:17:32PM +0800, Hillf Danton wrote:
> Hi Naoya
> 
> On Sat, Jan 28, 2012 at 7:02 AM, Naoya Horiguchi
> <n-horiguchi@ah.jp.nec.com> wrote:
> > Thp split is not necessary if we explicitly check whether pmds are
> > mapping thps or not. This patch introduces this check and adds code
> > to generate pagemap entries for pmds mapping thps, which results in
> > less performance impact of pagemap on thp.
> >
> 
> Could the method proposed here cover the two cases of split THP in mem cgroup?

No for now, but yes if "move charge" function supports THP.
I think this can be a bit large step so it is the next work.

Thanks,
Naoya
