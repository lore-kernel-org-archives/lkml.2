Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab2E3I3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 04:29:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50659 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153Ab2E3I3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 04:29:18 -0400
Date: Wed, 30 May 2012 17:29:07 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 00/16]
Message-ID: <20120530082907.GB32121@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

Here are my additional impressions after trying to read a bit more
from make_request.

* Single char variable names suck.  It's difficult to tell what type
  they are, what they're used for and makes it difficult to track
  where the variable is used in the function - try to highlight the
  variable name in the editor.

  While not a strict rule, there are reasons why people tend to use
  single char variable names mostly for specific things - e.g. loop
  variables, transient integral variables or in numerical context.
  They're either localized to small scope of code so keeping track of
  them is easy and/or people are familiar with such usages.

  So, I would *much* prefer if I don't have to keep trying to track
  what the hell c, d, k, j, l mean and where they're used.

* Due to the various style issues, lack of documentation and other
  abundant idiosyncrasies in the code, at least I find the code almost
  aggravating.  It's complicated, difficult to read and full of
  unnecessary differences and smart tricks (smart is not a positive
  word here).  I don't think we want code like this in the kernel.
  Hell, I would get pretty upset if I encounter this type of code
  while trying to update some block API.

* Maybe I haven't seen enough of it but my feeling about closure
  hasn't gone up.  It likely has gone further down.  It doesn't
  actually seem to solve the pain points of async programming while
  adding ample headaches.  The usages that I followed could be easily
  served by either domain-specific async sequencer or the existing ref
  / async / whatever mechanism / convention.  If you have good example
  usage in bcache, please feel free to explain it.

So, I don't know.  If this is a driver for some super obscure device
that would fall out of use in some years and doesn't interact with /
affect the rest of the kernel, maybe we can put it in with big giant
blinking red warnings about the dragons inside, but as it currently
stands I don't think I can ack the code base and am afraid that it
would need non-trivial updates to be upstreamable.

I'm gonna stop reading and, for now

 NACKED-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
