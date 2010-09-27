Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab0I0CBs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 22:01:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54721 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab0I0CBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 22:01:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad forfile/email/web servers
Cc: kosaki.motohiro@jp.fujitsu.com, Rob Mueller <robm@fastmail.fm>,
        linux-kernel@vger.kernel.org, Bron Gondwana <brong@fastmail.fm>,
        linux-mm <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20100921090407.GA11439@csn.ul.ie>
References: <52C8765522A740A4A5C027E8FDFFDFE3@jem> <20100921090407.GA11439@csn.ul.ie>
Message-Id: <20100927110049.6B31.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 27 Sep 2010 11:01:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> No doubt this is true. The only real difference is that there are more NUMA
> machines running mail/web/file servers now than there might have been in the
> past. The default made sense once upon a time. Personally I wouldn't mind
> the default changing but my preference would be that distribution packages
> installing on NUMA machines would prompt if the default should be changed if it
> is likely to be of benefit for that package (e.g. the mail, file and web ones).

At first impression, I thought this is cute idea. But, after while thinking, I've found some
weak point. The problem is, too many package need to disable zone_reclaim_mode.
zone_reclaim doesn't works fine if an application need large working set rather than
local node size. It mean major desktop applications (e.g. OpenOffice.org, Firefox, GIMP)
need to disable zone_reclaim. It mean even though basic package installation require 
zone_reclaim disabling. Then, this mechanism doesn't works practically. Even though
the user hope to use the machine for hpc, disable zone_reclaim will be turn on anyway.

Probably, opposite switch (default is zone_reclaim=0, and installation MPI library change
to zone_reclaim=1) might works. but I can guess why you don't propose this one.

Hmm....


