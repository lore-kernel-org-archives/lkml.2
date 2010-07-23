Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab0GWFri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:47:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60923 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab0GWFrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:47:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Ted Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [BUG] ext4 trace events cause NULL pointer dereferences
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100723011315.GC16373@thunk.org>
References: <20100722054957.GA11670@infradead.org> <20100723011315.GC16373@thunk.org>
Message-Id: <20100723144549.88BA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 23 Jul 2010 14:47:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jul 22, 2010 at 01:49:57AM -0400, Christoph Hellwig wrote:
> > 
> > I think ext4 is simply using an incorrectly typed tracepoint here.
> > If you want it to be useful in any way it needs a sb paramter and
> > an optional inode paramter, not the allocation context.
> 
> I agree; this is the patch that I had whipped up to fix the problem.
> (See below)

I'm not familiar ext4 so much. but you patch seems very nice!
thank you :)

> 
> > Also the whole ext4_mb_release_group_pa function seems to be a bit
> > misdesigned.  The code using ac is a totally separate block at the
> > end of the function and does work that's unrelated to the rest
> > of the function.  Just making it a separate helper can calling it
> > only from those places that have the allocation context would make
> > the code more clear.
> 
> I need to look more closely at this.  If I had time there would be a
> lot of things that I'd be refactoring and cleaning up in mballoc.c....


