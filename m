Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1C2REe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 13:04:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:41023 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1C2REd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 13:04:33 -0400
Subject: Re: [RFC PATCH] perf report: add sort by file lines
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1301418183.2250.416.camel@laptop>
References: <1301391136.14111.98.camel@minggr.sh.intel.com>
	 <1301392457.4859.74.camel@twins>  <1301417155.3620.8.camel@localhost>
	 <1301418183.2250.416.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 19:06:44 +0200
Message-ID: <1301418404.2250.417.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 19:03 +0200, Peter Zijlstra wrote:
> > Is it an unwind of the call frame stack to find out what data member was
> > accessed?
> 
> No need to unwind stacks, DWARF should have information on function
> local stack. It should be able to tell you the type of things like -8(%
> rbp). 

That is, we don't even have a life stack to unwind, so we simply cannot
unwind at all, but the debug information should be able to tell you the
type of whatever would live at a certain stack position if we were to
have a stack.

