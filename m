Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab1CBKJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:09:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756735Ab1CBKJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:09:08 -0500
Date: Wed, 2 Mar 2011 18:12:53 +0800
From: Han Pingtian <phan@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [BUG] perf failed on multi-cpus system with multi-events
 specified
Message-ID: <20110302101253.GA12300@hpt.nay.redhat.com>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	linux-kernel@vger.kernel.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>
References: <20110302035821.GA5186@hpt.nay.redhat.com>
 <1299058716.2428.13473.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299058716.2428.13473.camel@twins>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 10:38:36AM +0100, Peter Zijlstra wrote:
> On Wed, 2011-03-02 at 11:58 +0800, Han Pingtian wrote:
> >   Error: sys_perf_event_open() syscall returned with -1 (Too many open
> > files).  /bin/dmesg may provide additional information.
> 
> Well, you tried to use 42 events (quick count), we need to open a fd for
> each cpu for each event, which results in 1008 fds, which together with
> some actual file handles might have tickled your fd limit.
Got it. Thanks.

-- 
Han Pingtian
Quality Engineer
hpt @ #kernel-qe
Red Hat, Inc
Freedom ... courage ... Commitment ... ACCOUNTABILITY
