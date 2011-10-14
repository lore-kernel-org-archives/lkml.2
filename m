Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab1JNJ1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:27:13 -0400
Received: from mga05.intel.com ([192.55.52.89]:39609 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755915Ab1JNJ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:27:10 -0400
Subject: Re: linux-next: build failure after merge of the final tree
 (sparc, ptrace trees related)
From: Matt Fleming <matt.fleming@intel.com>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, oleg@redhat.com,
        linux-arch <linux-arch@vger.kernel.org>
In-Reply-To: <20111014.035459.2238341687770152474.davem@davemloft.net>
References: <20111014180714.e11e15fd35dfaca839c6421e@canb.auug.org.au>
	 <20111014.035459.2238341687770152474.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Fri, 14 Oct 2011 10:27:02 +0100
Message-ID: <1318584422.23581.118.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 03:54 -0400, David Miller wrote:
> Ptrace folks can we not operate like this?  The only reason I found
> out about the set_current_blocked() transformations was by accident,
> because the original patch was posted to linux-kernel only so it never
> got queued up into sparc patchwork.
> 
> Then once Oleg mentioned it to me, it didn't even compile so I fixed
> it up and put the fixed up copy into my tree.  It also didn't
> transform the TS_RESTORE_SIGMASK cases in the sparc signal code, so I
> also added a patch to the sparc tree which took care of that.
> 
> Now you guys are creating conflicts against those fixed up patches in
> another non-sparc tree, and adding new kinds of build failures as
> well.
> 
> This doesn't work.

Sorry David, this is my fault.

The reason that these patches couldn't be taken through the arch trees
was because they were dependent on the non-arch patch that introduced
block_sigmask(). I figured it would make more sense to put all the
patches through Oleg's tree. It's now pretty clear I was wrong about
that.

In hindsight, what I should have done was got the first patch that
introduced block_sigmask() into 3.1, then waited till the next release
cycle and sent out all the arch patches to the arch maintainers. That
way the patches could have been pulled into the respective arch trees.

Guys, how did you want to sort this out? Should we get the first patch
into 3.1, then get all the arch maintainers to pick up their patches?

