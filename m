Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab1DALFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 07:05:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58687 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab1DALFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 07:05:37 -0400
Subject: Re: [RFC PATCH] perf report: add sort by file lines
From: Peter Zijlstra <peterz@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
In-Reply-To: <4D95AC94.1080303@hitachi.com>
References: <1301391136.14111.98.camel@minggr.sh.intel.com>
	 <1301392457.4859.74.camel@twins> <1301417155.3620.8.camel@localhost>
	 <1301418183.2250.416.camel@laptop> <1301418404.2250.417.camel@laptop>
	 <1301418533.2250.419.camel@laptop>
	 <20110329174556.GC24129@ghostprotocols.net> <4D92818A.8020405@hitachi.com>
	 <1301561155.14111.288.camel@minggr.sh.intel.com>
	 <1301580117.4859.286.camel@twins>  <1301582056.2271.15.camel@localhost>
	 <1301588922.2250.498.camel@laptop>  <4D95AC94.1080303@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 01 Apr 2011 13:05:03 +0200
Message-ID: <1301655903.4859.494.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 19:44 +0900, Masami Hiramatsu wrote:
> E.g. an indirect jump makes it hard to find where it jumps to.

Yes indirect jumps are 'interesting', is there anything in the debug
info that will help us out with the possible target sites?

Also what generates indirect jumps, switch() stmts? Indirect function
call that get optimized might also be, but hopefully DWARF would tell us
about that and allow us to know the state right after the jump.
