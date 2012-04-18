Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2DRQOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 12:14:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53774 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065Ab2DRQOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 12:14:45 -0400
Date: Wed, 18 Apr 2012 17:14:35 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        majianpeng <majianpeng@gmail.com>
Subject: Re: Possible memory leaks in proc_sysctl.c
Message-ID: <20120418161435.GJ1505@arm.com>
References: <20120418101231.GE1505@arm.com>
 <m1wr5d18fy.fsf@fess.ebiederm.org>
 <20120418141851.GG1505@arm.com>
 <m1ipgxrt11.fsf@fess.ebiederm.org>
 <20120418151545.GI1505@arm.com>
 <m1ehrloxic.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ehrloxic.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 04:44:27PM +0100, Eric W. Biederman wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> > On Wed, Apr 18, 2012 at 03:52:58PM +0100, Eric W. Biederman wrote:
> >> So simply saying kmemleak shut up this is deliberate in these few cases
> >> where we don't intend to unregister the structure and have a deliberate
> >> leak seems the clean and maintainable way to go.
> >
> > OK, I got it now, sounds fair. But please add a comment to the
> > kmemleak_not_leak() annotations so that others know it's a deliberate
> > leak (rather than a false positive).
> >
> > Also the patch should include the linux/kmemleak.h file for the
> > kmemleak_not_leak() prototype as header changes in the future may cause
> > problems (I think the one you posted did not include it).
> 
> I will take a look when I merge the patch.
> 
> Would something like kmemleak_ignore() be better?  What I want is
> kmemleak_this_is_a_deliberate_leak_so_shut_up(), but the API doesn't
> seem to exactly include that function.  I'm not certain what the proper
> name is as I haven't worked much with kmemleak.

kmemleak_ignore() can be used as long as the object does not reference
other objects since it won't even be scanned. In this case, it only
hides the returned header object but there seem to be two more objects
allocated during the register_sysctl_table() call and referenced from
the returned header.

kmemleak_not_leak() would do the right thing here, though it was meant
for annotating false positives rather than real leaks. I think a comment
on the calling site would be enough.

-- 
Catalin
