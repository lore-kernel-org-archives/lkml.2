Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab2ITPiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 11:38:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:22594 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880Ab2ITPiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 11:38:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,454,1344236400"; 
   d="scan'208";a="224642576"
Date: Thu, 20 Sep 2012 23:32:09 +0800
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: <mingo@elte.hu>, <a.p.zijlstra@chello.nl>, <andi@firstfloor.org>,
        <namhyung@kernel.org>, <dsahern@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] perf tool: Add a global variable "const char
 *input_name"
Message-ID: <20120920233209.7008669e@feng-i7>
In-Reply-To: <20120920150551.GD26278@infradead.org>
References: <1348150779-17707-1-git-send-email-feng.tang@intel.com>
	<20120920150551.GD26278@infradead.org>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012 12:05:51 -0300
Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Thu, Sep 20, 2012 at 10:19:39PM +0800, Feng Tang escreveu:
> > Currently many perf ommands annotate/evlist/report/script/lock etc
> > all support "-i" option to chose a specific perf data, and all
> > of them create a local "input_name" to save the file name for
> > that perf data.
> > 
> > So adding a global variable could unify all those local ones, and
> > it will also be useful for other codes which need to know the file name.
> 
> But I think the input_name should be passed as a parameter to whoever
> needs it. Think about 'perf diff', for instance, it deals with two
> perf.data files.

Yes, when I wrote the patch, I checked all "perf_session__new()" calls, and
found "perf diff" uses the "input_new" and "input_old", so I thought it
should be immune to this change :)

The reason I came up with this patch is, when I rewrote the script browser
patch, I need to know this "input_name" to run script's report func on,
but IIUC currently this info is only saved in struct perf_session, and in
the browser stage (report/annotate), the perf_session is already phased
out and I don't know how to get a reference for the perf_session to get
the "input_name" 

> 
> In general I think we should _remove_ more globals :-)

Understood.

Thanks,
Feng
