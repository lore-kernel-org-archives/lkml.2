Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab1K1UCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:02:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:59924 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab1K1UCu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:02:50 -0500
Message-ID: <1322510552.2921.167.camel@twins>
Subject: Re: [PATCH 4/9] ftrace: Add enable/disable ftrace_ops control
 interface
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Nov 2011 21:02:32 +0100
In-Reply-To: <1322508398.17003.9.camel@frodo>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-5-git-send-email-jolsa@redhat.com>
	 <1322508398.17003.9.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 14:26 -0500, Steven Rostedt wrote:
> 
> Are jump labels safe in NMI context yet? If not, this will need to wait
> till we make it so. 

I don't think they are, we currently very much rely on that
stop_machine() crap. NMIs can go straight through that.

I think you can make it work with the stop_machine()-less approach,
because then the NMI will trap on the INT3 which will wait for
completion, sync and resume the NMI.

That of course relies on the NMI vs IRET crap getting sorted.

But even then, that's highly arch specific and I'm not sure we can make
all archs that support both jump_label and NMIs work.


