Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967924Ab2ERKOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:14:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:54439 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967647Ab2ERKOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:14:09 -0400
Message-ID: <1337336040.573.12.camel@twins>
Subject: Re: [PATCH 1/2] perf: Add persistent event facilities
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Fri, 18 May 2012 12:14:00 +0200
In-Reply-To: <1332340496-21658-2-git-send-email-bp@amd64.org>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
	 <1332340496-21658-2-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 15:34 +0100, Borislav Petkov wrote:
> +int perf_add_persistent_on_cpu(int cpu, struct pers_event_desc *desc,
> +                              struct dentry *dir, unsigned nr_pages) 

OK, so this creates an even and registers it somewhere in debugfs.

 - you allow an arbitrary place in debugfs; this might make finding them
'interesting'. Should we put them all in the same place?

 - persistent events created from userspace don't seem to get a debugfs
entry and will be lost forever?


In general I think a little more exploring of the semantics and
ramifications might be in order.
