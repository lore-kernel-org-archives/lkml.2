Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906Ab0LNUYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:24:49 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52759 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759576Ab0LNUYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:24:47 -0500
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
In-Reply-To: <20252.1292357637@localhost>
References: <20101213144646.341970461@intel.com>
	 <20101213150328.284979629@intel.com> <15881.1292264611@localhost>
	 <20101214065133.GA6940@localhost> <14658.1292352152@localhost>
	 <1292352908.13513.376.camel@laptop>  <20252.1292357637@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Dec 2010 21:24:15 +0100
Message-ID: <1292358255.13513.390.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 15:13 -0500, Valdis.Kletnieks@vt.edu wrote:
> So you're not guaranteed that 10*HZ is 10 seconds.  10*USER_HZ, sure.
> But not HZ.

You're confused. 10*HZ jiffies is always 10 seconds. Hertz means
per-second. We take CONFIG_HZ ticks per second, so waiting HZ jiffies
makes us wait 1 second.

USER_HZ is archaic and only used to stabilize user-interfaces that for
some daft reason depended on HZ.
