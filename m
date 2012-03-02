Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030479Ab2CBT5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 14:57:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759246Ab2CBT5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 14:57:02 -0500
Date: Fri, 2 Mar 2012 11:57:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Greg Thelen <gthelen@google.com>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/9] writeback: introduce the pageout work
Message-Id: <20120302115700.7d970497.akpm@linux-foundation.org>
In-Reply-To: <20120302103951.GA13378@localhost>
References: <20120228140022.614718843@intel.com>
	<20120228144747.198713792@intel.com>
	<20120228160403.9c9fa4dc.akpm@linux-foundation.org>
	<20120301123640.GA30369@localhost>
	<20120301163837.GA13104@quack.suse.cz>
	<20120302044858.GA14802@localhost>
	<20120302095910.GB1744@quack.suse.cz>
	<20120302103951.GA13378@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2012 18:39:51 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> > And I agree it's unlikely but given enough time and people, I
> > believe someone finds a way to (inadvertedly) trigger this.
> 
> Right. The pageout works could add lots more iput() to the flusher
> and turn some hidden statistical impossible bugs into real ones.
> 
> Fortunately the "flusher deadlocks itself" case is easy to detect and
> prevent as illustrated in another email.

It would be a heck of a lot safer and saner to avoid the iput().  We
know how to do this, so why not do it?

