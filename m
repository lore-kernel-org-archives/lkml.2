Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab1ELW3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:29:08 -0400
Received: from mail.perches.com ([173.55.12.10]:1587 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756442Ab1ELW3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:29:05 -0400
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>, Andy Whitcroft <apw@canonical.com>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1105121510330.9130@chino.kir.corp.google.com>
References: <1305073386-4810-1-git-send-email-john.stultz@linaro.org>
	 <1305073386-4810-3-git-send-email-john.stultz@linaro.org>
	 <1305075090.19586.189.camel@Joe-Laptop>  <1305076246.2939.67.camel@work-vm>
	 <1305076850.19586.196.camel@Joe-Laptop>
	 <alpine.DEB.2.00.1105121510330.9130@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 15:29:02 -0700
Message-ID: <1305239342.6124.77.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 15:12 -0700, David Rientjes wrote:
> On Tue, 10 May 2011, Joe Perches wrote:
> > > Although I'm not sure if there's precedent for a %p value that didn't
> > > take a argument. Thoughts on that? Anyone else have an opinion here?
> > The uses of %ptc must add an argument or else gcc will complain.
> > I suggest you just ignore the argument value and use current.
> That doesn't make any sense, why would you needlessly restrict this to 
> current when accesses to other threads' ->comm needs to be protected in 
> the same way?  I'd like to use this in the oom killer and try to get rid 
> of taking task_lock() for every thread group leader in the tasklist dump.

I suppose another view is coder stuffed up, let them suffer...

At some point, gcc may let us extend printf argument type
verification so it may not be a continuing problem.

Adding a checkpatch rule for this is non-trivial as it can
be written as:

	printk("%ptc\n",
	       current);

and checkpatch is mostly line oriented.

Andy, do you have a suggestion on how to verify
vsprintf argument types for checkpatch?

