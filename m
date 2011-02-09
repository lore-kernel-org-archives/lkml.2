Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab1BIViN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:38:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197Ab1BIViN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:38:13 -0500
Date: Wed, 9 Feb 2011 13:37:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] memcg: operate on page quantities internally
Message-Id: <20110209133757.735b08ab.akpm@linux-foundation.org>
In-Reply-To: <1297249313-23746-1-git-send-email-hannes@cmpxchg.org>
References: <1297249313-23746-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Feb 2011 12:01:49 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> Hi,
> 
> this patch set converts the memcg charge and uncharge paths to operate
> on multiples of pages instead of bytes.  It already was a good idea
> before, but with the merge of THP we made a real mess by specifying
> huge pages alternatingly in bytes or in number of regular pages.
> 
> If I did not miss anything, this should leave only res_counter and
> user-visible stuff in bytes.  The ABI probably won't change, so next
> up is converting res_counter to operate on page quantities.
> 

I worry that there will be unconverted code and we'll end up adding
bugs.

A way to minimise the risk is to force compilation errors and warnings:
rename fields and functions, reorder function arguments.  Did your
patches do this as much as they could have?

