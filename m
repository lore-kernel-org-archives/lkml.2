Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab1CaCdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 22:33:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756729Ab1CaCdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 22:33:20 -0400
Date: Wed, 30 Mar 2011 19:34:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH]mmap: improve scalability for updating vm_committed_as
Message-Id: <20110330193404.9525b4e9.akpm@linux-foundation.org>
In-Reply-To: <1301533003.3981.75.camel@sli10-conroe>
References: <1301447847.3981.49.camel@sli10-conroe>
	<20110330155114.fa47dd9d.akpm@linux-foundation.org>
	<1301533003.3981.75.camel@sli10-conroe>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 08:56:43 +0800 Shaohua Li <shaohua.li@intel.com> wrote:

> > This is a big change, and it wasn't even changelogged.  It's
> > potentially a tremendous increase in the expense of a read from
> > /proc/meminfo, which is a file that lots of tools will be polling. 
> > Many of those tools we don't even know about or have access to.
> Assume we don't read /proc/meminfo too often.

That's a poor assumption.  top(1) and vmstat(8) read it, for a start. 
There will be zillions of locally-developed monitoring tools which read
meminfo.

Now, it could be that something under meminfo reads _already_ does a
massive walk across all CPUs.  If so then we'll have already trained
people to avoid reading /proc/meminfo and this change might be
acceptable.

But if this isn't the case then it's quite likely that this change will
hurt some people quite a lot.  And, unfortunately, the sort of people
who we will hurt tend to be people who don't run our stuff until a long
time (years) after we wrote it.  By which time it's going to be quite
expensive to get a fix down the chain and into their hands.
