Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2BCNbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:31:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:32901 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab2BCNbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:31:17 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0ow4NSV8tcgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=utYEYZn4DkV86JrM_UkA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328275874.5882.137.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/5 v2] [GIT PULL] x86/jump label: Paranoid checks and 2
 or 5 byte nops
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 03 Feb 2012 08:31:14 -0500
In-Reply-To: <20120203073632.GB30543@elte.hu>
References: <20120128160925.275163704@goodmis.org>
	 <20120130144857.GA22013@elte.hu>
	 <1327936060.22710.165.camel@gandalf.stny.rr.com>
	 <20120131194813.GA12074@elte.hu>
	 <1328072925.5882.57.camel@gandalf.stny.rr.com>
	 <20120201080539.GA11770@elte.hu>
	 <1328109697.5882.65.camel@gandalf.stny.rr.com>
	 <20120202135154.GA10315@elte.hu> <4F2A9960.2090500@zytor.com>
	 <1328193068.5882.95.camel@gandalf.stny.rr.com>
	 <20120203073632.GB30543@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-03 at 08:36 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Now I'm running a ktest bisect on the out-of-tree branch to 
> > find the commit that prevents this box from booting. [...]
> 
> Let me know once you have found that and are able to boot -tip 
> with your new bits applied. tip:out-of-tree needs definitely 
> needs a cleanup - I'll probably even make it internal to my 
> testing to not uglify tip:master.

Found it. I found this once before, but couldn't find it when I looked,
but it was still there :-/

Anyway, here's the commit that prevents my box from booting:

commit 41e95d95208c62d4b0fbcee5f16d93e23ca32984
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Sep 17 23:12:20 2009 +0200

    <not-for-merge> Disable DEVTMPFS_MOUNT for now


It seems that this box requires DEVTMPFS_MOUNT to be set in order to
boot.

-- Steve


