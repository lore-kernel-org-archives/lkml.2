Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab0FJREa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 13:04:30 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:47794 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab0FJRE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 13:04:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wDjj3JzAJt8c3d+ml/2BHXiiVWu9D/SK0rpj/yMX+eWCK31LF0XzQKNfSgmQEUAUL7
         5BAZBOlzwgM6XOHVyZszJj7T8eljam9tedwRQ2lql93KLSQjH1cIoEs871BuRTC3OEWN
         H74oAjE8ILu4hVK3r/y/0mou8O9cdJG4EWbEU=
Date: Thu, 10 Jun 2010 19:04:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/5] perf: Provide a proper stop action for software
	events
Message-ID: <20100610170427.GG5255@nowhere>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com> <1276141760-11590-2-git-send-regression-fweisbec@gmail.com> <1276166813.2077.96.camel@twins> <1276168242.2077.134.camel@twins> <20100610161234.GA5255@nowhere> <1276186576.2077.554.camel@twins> <20100610162858.GD5255@nowhere> <1276187914.2077.579.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276187914.2077.579.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 06:38:34PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-10 at 18:29 +0200, Frederic Weisbecker wrote:
> 
> > Imagine you have several software and hardware events running on the
> > same cpu. Each time you reset this period for a software event, you do
> > a hw_pmu_disable() / hw_pmu_enable(), which writes/read the hardware
> > register for each hardware events, amongst other wasteful things.
> 
> hw_perf_disable/enable() are on their way out. They should be replaced
> with a struct pmu callback. We must remove all these weak functions if
> we want to support multiple pmus.


Ok, that's a good news.

