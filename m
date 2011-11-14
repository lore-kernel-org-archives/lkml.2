Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1KNSrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 13:47:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab1KNSrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 13:47:45 -0500
Date: Mon, 14 Nov 2011 13:47:17 -0500
From: Dave Jones <davej@redhat.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: long sleep_on_page delays writing to slow storage
Message-ID: <20111114184717.GA7006@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Johannes Weiner <jweiner@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mel Gorman <mgorman@suse.de>, Jan Kara <jack@suse.cz>,
	Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org,
	linux-mm@vger.kernel.org, kernel-team@fedoraproject.org
References: <20111107045928.GK8927@hexapodia.org>
 <20111109170027.GB7495@quack.suse.cz>
 <20111109175201.GB3083@suse.de>
 <20111109180646.GM5075@redhat.com>
 <20111110093442.GG3153@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110093442.GG3153@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 10:34:42AM +0100, Johannes Weiner wrote:
 
 > > I wonder if a change like this would be enough?
 > > 
 > >        sync_migration = !(gfp_mask & __GFP_NO_KSWAPD);
 > > 
 > > But even if hidden in a new function, the main downside overall is the
 > > fact we'll pass one more var through the stack of fast paths.
 > > 
 > > Johannes I recall you reported this too and Mel suggested the above
 > > change, did it help in the end?
 > 
 > Yes, it completely fixed the latency problem.
 > 
 > That said, I haven't looked at the impact on the THP success rate, but
 > a regression there is probably less severe than half-minute-stalls in
 > interactive applications.

FWIW, we've had a few reports from Fedora users since we moved to 3.x kernels
about similar problems, so whatever the fix is for this should probably
go to stable too.

I could push an update for Fedora users to test the change above if
that would be helpful ?

	Dave

