Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608Ab2EVPnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:43:18 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51583 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122Ab2EVPnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:43:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120522115910.GA3353@suse.de>
References: <20120517213120.GA12329@redhat.com> <20120518185851.GA5728@redhat.com>
 <20120521154709.GA8697@redhat.com> <CA+55aFyqMJ1X08kQwJ7snkYo6MxfVKqFJx7LXBkP_ug4LTCZ=Q@mail.gmail.com>
 <20120521200118.GA12123@redhat.com> <20120522115910.GA3353@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 May 2012 08:42:55 -0700
X-Google-Sender-Auth: byICSNg2DXhTbu-xEPfABGRp3Ac
Message-ID: <CA+55aFwdyt310Mcsk==58Qa-sZD05A=M+R06xwOisbg2gex=RA@mail.gmail.com>
Subject: Re: 3.4-rc7 numa_policy slab poison.
To: Mel Gorman <mgorman@suse.de>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 4:59 AM, Mel Gorman <mgorman@suse.de> wrote:
>
> This bug is really old as it triggers as far back as 2.6.32.58. I don't
> know why yet.

Would somebody humor me, and try it without the MPOL_F_SHARED games?
The whole reference counting in the presense of setting and clearing
that bit looks totally crazy. I really cannot see how it could ever
work.

I realize that it avoids a copy, but I really don't see how the
refcounting is supposed to work for it..

                       Linus
