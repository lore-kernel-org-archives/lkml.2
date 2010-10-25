Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab0JYAo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 20:44:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49996 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab0JYAoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 20:44:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmscan: move referenced VM_EXEC pages to active list
Cc: kosaki.motohiro@jp.fujitsu.com, Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, wad@chromium.org, olofj@chromium.org,
        Shaohua Li <shaohua.li@intel.com>
In-Reply-To: <AANLkTinWp-M4S5EXz6-xJvHAnzdk96_5+d2OJVjCycsm@mail.gmail.com>
References: <1287787911-4257-1-git-send-email-msb@chromium.org> <AANLkTinWp-M4S5EXz6-xJvHAnzdk96_5+d2OJVjCycsm@mail.gmail.com>
Message-Id: <20101025094235.9154.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 25 Oct 2010 09:44:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Oct 23, 2010 at 7:51 AM, Mandeep Singh Baines <msb@chromium.org> wrote:
> > In commit 64574746, "vmscan: detect mapped file pages used only once",
> > Johannes Weiner, added logic to page_check_reference to cycle again
> > used once pages.
> >
> > In commit 8cab4754, "vmscan: make mapped executable pages the first
> > class citizen", Wu Fengguang, added logic to shrink_active_list which
> > protects file-backed VM_EXEC pages by keeping them in the active_list if
> > they are referenced.
> >
> > This patch adds logic to move such pages from the inactive list to the
> > active list immediately if they have been referenced. If a VM_EXEC page
> > is seen as referenced during an inactive list scan, that reference must
> > have occurred after the page was put on the inactive list. There is no
> > need to wait for the page to be referenced again.
> >
> > Change-Id: I17c312e916377e93e5a92c52518b6c829f9ab30b
> > Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> 
> It seems to be similar to http://www.spinics.net/lists/linux-mm/msg09617.html.
> I don't know what it is going. Shaohua?

Hi Mandeep,

Yeah, if you have enough time, can you please consider to join this testing? or can you
please explain your interactivity experience if there is.

Thanks.




