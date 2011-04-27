Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab1D0GrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:47:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59866 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab1D0GrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:47:20 -0400
Date: Wed, 27 Apr 2011 02:47:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Ted Ts'o" <tytso@mit.edu>, Thiago Farina <tfransosi@gmail.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
Message-ID: <20110427064719.GB597@infradead.org>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
 <20110427005243.GI9486@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110427005243.GI9486@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 08:52:43PM -0400, Ted Ts'o wrote:
> I don't think this is not a good idea.
> 
> First of all, changing 2800 instances of strcmp will induce a huge
> amount of code churn, that will cause patches to break, etc.  And
> whether streq() looks better is going to be very much a case of
> personal preference.  I'm so used to !strcmp(a, b) that streq(a, b)
> would be harder for me, just because I'm not used to it.
> 
> So I'd NACK a change like this to any parts of the kernel that I'm
> maintaining.  If another people feel that way, it's not clear that
> having two different conventions in the kernel would necessarily help...

Same here.  Diverging from standard ANSI C just for the sake of being
different is an utterly bad idea.  strcmp might not be the most natural
calling convention, but it's been in the wild for 30 years, and everyone
taking a C 101 course should know about it.

And if you get it wrong and don't notice it just means your testing
coverage sucks badly.
