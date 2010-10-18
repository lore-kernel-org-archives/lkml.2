Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab0JRMFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:05:45 -0400
Received: from canuck.infradead.org ([134.117.69.58]:58936 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab0JRMFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:05:43 -0400
Subject: Re: [PATCH 5/9] jump label: Add
 register_jump_label_key/unregister_jump_label_key
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
In-Reply-To: <1287177215.1998.121.camel@laptop>
References: <20101015200949.134732894@goodmis.org>
	 <20101015201036.923619508@goodmis.org>  <1287176595.1998.116.camel@laptop>
	 <1287176974.16971.3.camel@gandalf.stny.rr.com>
	 <1287177215.1998.121.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Oct 2010 14:05:21 +0200
Message-ID: <1287403521.29097.1554.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 23:13 +0200, Peter Zijlstra wrote:
> On Fri, 2010-10-15 at 17:09 -0400, Steven Rostedt wrote:
> > On Fri, 2010-10-15 at 23:03 +0200, Peter Zijlstra wrote:
> > 
> > > Urgh, this sucks.. :-(
> > > 
> > > So now we have to actually track all JUMP_LABEL() sites and call
> > > register muck on them.. even though we already track them through the
> > > special data section.
> > > 
> > > Is there really no way around this?
> > 
> > I'll take a look to see if we can monkey with magic and automate it.
> 
> So the problem is something like:
> 
> core kernel:
> 
>  jump_label_enable()
> 
> module:
> 
>  JUMP_LABEL()
> 
> And then because we don't have a proper __jump_table section, the
> jump_label_enable() won't properly work?
> 
> Why not let jump_label_enable() add a dummy entry with the enabled bit
> and once you load the module merge the real entry into it.

Or actually use the value of the key pointer.. it would mean either
standardizing the size (int/atomic_t would work), or using a version of
the fallback JUMP_LABEL implementation to sort out the type issues.
