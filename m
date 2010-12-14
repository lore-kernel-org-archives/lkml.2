Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab0LNS4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 13:56:19 -0500
Received: from canuck.infradead.org ([134.117.69.58]:37413 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab0LNS4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 13:56:17 -0500
Subject: Re: [PATCH 16/35] writeback: increase min pause time on concurrent
 dirtiers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Valdis.Kletnieks@vt.edu
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <14658.1292352152@localhost>
References: <20101213144646.341970461@intel.com>
	 <20101213150328.284979629@intel.com> <15881.1292264611@localhost>
	 <20101214065133.GA6940@localhost>  <14658.1292352152@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Dec 2010 19:55:08 +0100
Message-ID: <1292352908.13513.376.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 13:42 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 14 Dec 2010 14:51:33 +0800, Wu Fengguang said:
> 
> > > > +	/* (N * 10ms) on 2^N concurrent tasks */
> > > > +	t = (hi - lo) * (10 * HZ) / 1024;
> > > 
> > > Either I need more caffeine, or the comment doesn't match the code
> > > if HZ != 1000?
> > 
> > The "ms" in the comment may be confusing, but the pause time (t) is
> > measured in jiffies :)  Hope the below patch helps.
> 
> No, I meant that 10 * HZ evaluates to different numbers depending what
> the CONFIG_HZ parameter is set to - 100, 250, 1000, or some other
> custom value.  Does this code behave correctly on a CONFIG_HZ=100 kernel?

10*HZ = 10 seconds
(10*HZ) / 1024 ~= 10 milliseconds
