Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293Ab0KQMvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:51:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:54759 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab0KQMvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:51:43 -0500
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Peter Zijlstra <peterz@infradead.org>
To: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20101117144758.38bf4f05@deb0>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <20101117144758.38bf4f05@deb0>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 13:51:52 +0100
Message-ID: <1289998312.2109.745.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 14:47 +0200, Török Edwin wrote:
> I see --call-graph in the trace record -h output, but it doesn't seem
> to work on x86_64 for me.

If you want to unwind userspace you need to build everything with
framepointers -- sadly some people have been lobbying to remove
framepointers from all distro builds, even though on x86_64 its nearly
free (i386 does have a significant performance benefit, sadly).

There's some work on-going to simply copy out the top of stack and let
dwarves go wild at it in userspace, but that isn't done yet.

