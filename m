Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab2EaQ4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 12:56:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:37754 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2EaQ4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 12:56:31 -0400
Message-ID: <1338483372.28384.65.camel@twins>
Subject: Re: [PATCH 1/3] uprobes/core: Remove redundant lock_page/unlock_page
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>
Date: Thu, 31 May 2012 18:56:12 +0200
In-Reply-To: <20120531150756.GC24279@linux.vnet.ibm.com>
References: <20120531114630.23691.33166.sendpatchset@srdronam.in.ibm.com>
	 <1338465518.28384.55.camel@twins>
	 <20120531150756.GC24279@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 20:37 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2012-05-31 13:58:38]:
> 
> > On Thu, 2012-05-31 at 17:16 +0530, Srikar Dronamraju wrote:
> > > From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> > > 
> > > No need to lock the page when copying the opcode in read_opcode().
> > 
> > It would be good if the changelog said _why_ this is so :-)
> 
> In read_opcode(), we have the reference for the page and we only are reading
> from the the page. i.e we are neither modifying the page contents, not
> the page attributes. 

Fair enough, so put that in the changelog. The changelog should explain
things, not raise questions.

> Existing kernel code has enough examples where we read the contents
> of the page without taking the page lock.

Yes, but that doesn't tell us this site is ok, doing it because others
do isn't an argument.

> Further this was discussed here too https://lkml.org/lkml/2012/4/17/361.

That wasn't a discussion, that was two people saying they don't know.
