Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0IFSfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:35:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54711 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab0IFSfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:35:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/4] swap: prevent reuse during hibernation
Date: Mon, 6 Sep 2010 20:34:36 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Andrea Gelmini <andrea.gelmini@gmail.com>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Nigel Cunningham <nigel@tuxonice.net>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <alpine.LSU.2.00.1009060104410.13600@sister.anvils> <alpine.LSU.2.00.1009060111220.13600@sister.anvils> <20100906171504.f06918a1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100906171504.f06918a1.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009062034.36437.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 06, 2010, KAMEZAWA Hiroyuki wrote:
> On Mon, 6 Sep 2010 01:12:38 -0700 (PDT)
> Hugh Dickins <hughd@google.com> wrote:
> 
> > Move the hibernation check from scan_swap_map() into try_to_free_swap():
> > to catch not only the common case when hibernation's allocation itself
> > triggers swap reuse, but also the less likely case when concurrent page
> > reclaim (shrink_page_list) might happen to try_to_free_swap from a page.
> > 
> > Hibernation already clears __GFP_IO from the gfp_allowed_mask, to stop
> > reclaim from going to swap: check that to prevent swap reuse too.
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Cc: Ondrej Zary <linux@rainbow-software.org>
> > Cc: Andrea Gelmini <andrea.gelmini@gmail.com>
> > Cc: Balbir Singh <balbir@in.ibm.com>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Cc: Nigel Cunningham <nigel@tuxonice.net>
> > Cc: stable@kernel.org
> 
> Hmm...seems better.
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
