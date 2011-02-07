Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1BGVWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:22:54 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:57990 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab1BGVWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:22:53 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.45
X-Originating-IP: 173.50.155.44
Date: Mon, 7 Feb 2011 13:22:22 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/4] tracing,x86_64 - function/graph trace without
 mcount/-pg/framepointer
Message-ID: <20110207212220.GA30070@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 23, 2000 at 10:56:55AM +0000, Steven Rostedt wrote:
> On Thu, 2011-02-03 at 16:42 +0100, Jiri Olsa wrote:
> > hi,
> > 
> > I recently saw the direct jump probing made for kprobes
> > and tried to use it inside the trace framework.
> > 
> > The global idea is patching the function entry with direct
> > jump to the trace code, instead of using pregenerated gcc
> > profile code.
> 
> Interesting, but ideally, it would be nice if gcc provided a better
> "mcount" mechanism. One that calls mcount (or whatever new name it would
> have) before it does anything with the stack.

GCC 4.6 may help here.  According to
http://gcc.gnu.org/gcc-4.6/changes.html:

"Support for emitting profiler counter calls before function prologues.
This is enabled via a new command-line option -mfentry."

Looks like that option might only support x86 (32-bit and 64-bit) at the
moment, but it still seems like an improvement over the current
mechanism to work around GCC's placement of mcount.

- Josh Triplett
