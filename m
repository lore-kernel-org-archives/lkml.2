Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab2IYKdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:33:09 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39461 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754703Ab2IYKdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:33:08 -0400
Message-ID: <1348569181.2457.26.camel@dabdike>
Subject: Re: [RFC] mm: add support for zsmalloc and zcache
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Date: Tue, 25 Sep 2012 14:33:01 +0400
In-Reply-To: <50609794.8030508@linux.vnet.ibm.com>
References: <1346794486-12107-1-git-send-email-sjenning@linux.vnet.ibm.com>
	 <20120921161252.GV11266@suse.de>
	 <20120921180222.GA7220@phenom.dumpdata.com>
	 <505CB9BC.8040905@linux.vnet.ibm.com>
	 <42d62a30-bd6c-4bd7-97d1-bec2f237756b@default>
	 <50609794.8030508@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 12:25 -0500, Seth Jennings wrote:
> In summary, I really don't understand the objection to
> promoting zcache and integrating zcache2 improvements and
> features incrementally.  It seems very natural and
> straightforward to me.  Rewrites can even happen in
> mainline, as James pointed out.  Adoption in mainline just
> provides a more stable environment for more people to use
> and contribute to zcache.

This is slightly disingenuous.  Acceptance into mainline commits us to
the interface.  Promotion from staging with simultaneous deprecation
seems like a reasonable (if inelegant) compromise, but the problem is
it's not necessarily a workable solution: as long as we have users of
the interface in mainline, we can't really deprecate stuff however many
feature deprecation files we fill in (I've had a deprecated SCSI ioctl
set that's been deprecated for ten years and counting).  What worries me
looking at this fight is that since there's a use case for the old
interface it will never really get removed.

Conversely, rewrites do tend to vastly increase the acceptance cycle
mainly because of reviewer fatigue (and reviews are our most precious
commodity in the kernel).  I'm saying rewrites should be possible in
staging because it was always possible on plain patch submissions; I'm
not saying they're desirable.  Every time I've seen a rewrite done, it
has added ~6mo-1yr to the acceptance cycle.  I sense that the fatigue
factor with transcendent memory is particularly high, so we're probably
looking at the outside edge of the estimate, so the author needs
seriously to consider if the rewrite is worth this.

Oh, and while this spat goes on, the stalemate is basically assured and
external goodwill eroding.  So, for god's sake find a mutually
acceptable compromise, because we're not going to find one for you.

James


