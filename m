Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422978Ab2JaOpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:45:00 -0400
Received: from aserp1050.oracle.com ([141.146.126.70]:18534 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965266Ab2JaOo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:44:58 -0400
MIME-Version: 1.0
Message-ID: <c0d68556-54e7-479a-a7ae-6ca6f136d62d@default>
Date: Wed, 31 Oct 2012 07:42:39 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: RE: [PATCH 0/2] mm: do not call frontswap_init() during swapoff
References: <<1351372847-13625-1-git-send-email-cesarb@cesarb.net>>
In-Reply-To: <<1351372847-13625-1-git-send-email-cesarb@cesarb.net>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: aserp1040.oracle.com [141.146.126.69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Cesar Eduardo Barros [mailto:cesarb@cesarb.net]
> Sent: Saturday, October 27, 2012 3:21 PM
> To: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org; Konrad Rzeszutek Wilk; Dan Magenheimer; Andrew Morton; Mel Gorman;
> Rik van Riel; KAMEZAWA Hiroyuki; Johannes Weiner; Cesar Eduardo Barros
> Subject: [PATCH 0/2] mm: do not call frontswap_init() during swapoff
> 
> The call to frontswap_init() was added in a place where it is called not
> only from sys_swapon, but also from sys_swapoff. This pair of patches
> fixes that.
> 
> The first patch moves the acquisition of swap_lock from enable_swap_info
> to two separate helpers, one for sys_swapon and one for sys_swapoff. As
> a bonus, it also makes the code for sys_swapoff less subtle.
> 
> The second patch moves the call to frontswap_init() from the common code
> to the helper used only by sys_swapon.
> 
> Compile-tested only, but should be safe.
> 
> Cesar Eduardo Barros (2):
>   mm: refactor reinsert of swap_info in sys_swapoff
>   mm: do not call frontswap_init() during swapoff
> 
>  mm/swapfile.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)

Belated but, I'm told, better late than never.

Minimally tested to ensure that frontswap continues
to work properly with some disk swap activity, not
exhaustively tested for swap in general.

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
