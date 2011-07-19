Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab1GSIxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 04:53:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:11458 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab1GSIxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 04:53:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,227,1309762800"; 
   d="scan'208";a="29303371"
Subject: Re: [PATCH]vmscan: fix a livelock in kswapd
From: Shaohua Li <shaohua.li@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "mgorman@suse.de" <mgorman@suse.de>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <CAEwNFnB6HKJ3j9cWzyb2e3BS2BQrE66F6eT02C4cozRC9YQ7kw@mail.gmail.com>
References: <1311059367.15392.299.camel@sli10-conroe>
	 <CAEwNFnB6HKJ3j9cWzyb2e3BS2BQrE66F6eT02C4cozRC9YQ7kw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 16:53:04 +0800
Message-ID: <1311065584.15392.300.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 16:45 +0800, Minchan Kim wrote:
> On Tue, Jul 19, 2011 at 4:09 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> > I'm running a workload which triggers a lot of swap in a machine with 4 nodes.
> > After I kill the workload, I found a kswapd livelock. Sometimes kswapd3 or
> > kswapd2 are keeping running and I can't access filesystem, but most memory is
> > free. This looks like a regression since commit 08951e545918c159.
> 
> Could you tell me what is 08951e545918c159?
> You mean [ebd64e21ec5a,
> mm-vmscan-only-read-new_classzone_idx-from-pgdat-when-reclaiming-successfully]
> ?
ha, sorry, I should copy the commit title.
08951e545918c159(mm: vmscan: correct check for kswapd sleeping in
sleeping_prematurely)

