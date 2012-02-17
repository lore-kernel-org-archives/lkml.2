Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab2BQSIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:08:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:51676 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab2BQSIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:08:10 -0500
Message-ID: <1329502078.2293.286.camel@twins>
Subject: Re: [PATCH 1/2] rmap: Staticize page_referenced_file and
 page_referenced_anon
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Fri, 17 Feb 2012 19:07:58 +0100
In-Reply-To: <CAFPAmTRrW4rAiC6UPGCFWChyuAjtbn7pkXRm3L2_SYdrRQCBZQ@mail.gmail.com>
References: <1329488869-7270-1-git-send-email-consul.kautuk@gmail.com>
	 <1329491708.2293.277.camel@twins>
	 <CAFPAmTRrW4rAiC6UPGCFWChyuAjtbn7pkXRm3L2_SYdrRQCBZQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 10:19 -0500, Kautuk Consul wrote:
> > Also, if they're static and there's only a single callsite, gcc will
> > already inline them, does this patch really make a difference?
> 
> I just sent this patch for what I thought was "correctness", but I guess
> we can let this be if you are absolutely sure that all GCC cross compilers
> for all platforms will guarantee inlining. 

Typically we don't explicitly inline such large functions, unless we
need it for performance.
