Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab2EQQWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:22:39 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37353 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760229Ab2EQQWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:22:35 -0400
Date: Thu, 17 May 2012 13:22:30 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Feng Tang <feng.tang@intel.com>, mingo@elte.hu, a.p.zijlstra@chello.nl,
        robert.richter@amd.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] perf script: Replace "struct thread" with "struct
 addr_location" as a parameter for "process_event()"
Message-ID: <20120517162229.GD12911@infradead.org>
References: <1337173155-25780-1-git-send-email-feng.tang@intel.com>
 <1337173155-25780-2-git-send-email-feng.tang@intel.com>
 <20120517154521.GB2636@infradead.org>
 <4FB52270.2060505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB52270.2060505@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 17, 2012 at 10:08:16AM -0600, David Ahern escreveu:
> On 5/17/12 9:45 AM, Arnaldo Carvalho de Melo wrote:
> >Em Wed, May 16, 2012 at 08:59:14PM +0800, Feng Tang escreveu:
> >>Both perl and python script start processing events other than trace
> >>points, and it's useful to pass the resolved symbol and the dso info
> >>to the event handler in script for better analysis and statistics.
> >>
> >>Struct thread is already a member of struct addr_location, using
> >>addr_location will keep the thread info, while providing additional
> >>symbol and dso info if exist, so that the script itself doesn't need
> >>to bother to do the symbol resolving and dso searching work.
> >
> >This seems ok.
> >
> >David, any objections or suggestions?
> 
> perf_event__preprocess_sample calls thread__find_addr_map which sets
> al->thread and the preprocess_sample is invoked prior to
> process_event, so it should be fine.
> 
> That said, I would like to test it. Unfortunately I am knee deep
> debugging some local perf breakage. Give me a couple of days to get
> back to this.

Thanks!

- Arnaldo
