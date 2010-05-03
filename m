Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab0ECQdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 12:33:09 -0400
Received: from tex.lwn.net ([70.33.254.29]:35324 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933321Ab0ECQdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 12:33:06 -0400
Date: Mon, 3 May 2010 10:33:00 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: mgross@linux.intel.com
Cc: Kevin Hilman <khilman@deeprootsystems.com>, aili@codeaurora.org,
       dwalker@codeaurora.org, tiwai@suse.de, bruce.w.allan@intel.com,
       davidb@quicinc.com, mcgrof@gmail.com, pavel@ucw.cz,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]PM QOS refresh against next-20100430
Message-ID: <20100503103300.6330e522@bike.lwn.net>
In-Reply-To: <20100430212043.GA30315@linux.intel.com>
References: <20100430212043.GA30315@linux.intel.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010 14:20:43 -0700
mark gross <mgross@linux.intel.com> wrote:

> This patch changes the string based list management to a handle base
> implementation to help with the hot path use of pm-qos

Having taken a quick look, I think the API change makes a lot of
sense.  Hot paths are one thing; avoidance of accidental conflicts
would be another.

One question, though...  one clear use of this API is for drivers to
say "don't go into C3 or deeper because things go wrong"; I'm about to
add another one of those.  It works, but the use of a
PM_QOS_CPU_DMA_LATENCY requirement with a hard-coded number that one
hopes is small enough seems a bit...indirect.  I wonder if it would be
clearer and more robust to add a new requirement^Wrequest type saying
"the quality of service I need is shallow sleeps only"?

jon
