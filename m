Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab1H3Lfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:35:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44655 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1H3Lf3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:35:29 -0400
Subject: Re: [RFC PATCH] x86: perf: Clean up perf_event cpu code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Aug 2011 13:35:15 +0200
In-Reply-To: <1314703291-3080-1-git-send-email-kjwinchester@gmail.com>
References: <1314105839.8002.51.camel@twins>
	 <1314703291-3080-1-git-send-email-kjwinchester@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314704115.2799.12.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 08:21 -0300, Kevin Winchester wrote:
> 
> This is the first time I've attempted a patch this large.  Should I break it up
> into smaller pieces?  

Only if it makes sens, intermediate stages should still compile. I could
imagine you creating the header file and moving stuff in there one thing
at a time while keeping the whole thing compiling. Eventually resulting
in the state where the #include hackery is superfluous and can be
removed.

If its worth spending a lot of time making that happen is another thing.

> Or does that requirement not really apply since it's just
> a cleanup patch?

Cleanup isn't the criteria. The individual steps have to make sense.

Take for instance the uprobe patch set as an example of how not to split
up things. The individual patches don't really stand on their own and
you're constantly forced to switch back and forth while reviewing, a
total pain.

> Also, it is based on Linus' tree, should I base it on tip instead?

Yes please. I don't think they differ a lot but tip is where it'll end
up being applied to, so it helps if it does indeed apply ;-)

Otherwise looks good, thanks a bunch!
