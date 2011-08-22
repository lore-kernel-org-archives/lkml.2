Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1HVXia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:38:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589Ab1HVXi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:38:28 -0400
Date: Mon, 22 Aug 2011 16:38:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vmscan: fix initial shrinker size handling
Message-Id: <20110822163821.e746ab25.akpm@linux-foundation.org>
In-Reply-To: <20110822232257.GT3162@dastard>
References: <20110822101721.19462.63082.stgit@zurg>
	<20110822232257.GT3162@dastard>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011 09:22:57 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Aug 22, 2011 at 02:17:21PM +0300, Konstantin Khlebnikov wrote:
> > Shrinker function can returns -1, it means it cannot do anything without a risk of deadlock.
> > For example prune_super() do this if it cannot grab superblock refrence, even if nr_to_scan=0.
> > Currenly we interpret this like ULONG_MAX size shrinker, evaluate total_scan according this,
> > and next time this shrinker can get really big pressure. Let's skip such shrinkers instead.
> > 
> > Also make total_scan signed, otherwise check (total_scan < 0) below never works.
> 
> I've got a patch set I am going to post out today that makes this
> irrelevant.

Well, how serious is the bug?  If it's a non-issue then we can leave
the fix until 3.1.  If it's a non-non-issue then we'd need a minimal
patch to fix up 3.1 and 3.0.x.

