Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab2IUJ5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:57:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab2IUJ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:57:51 -0400
Date: Fri, 21 Sep 2012 10:57:47 +0100
From: Mel Gorman <mgorman@suse.de>
To: Glauber Costa <glommer@parallels.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: MMTests 0.05
Message-ID: <20120921095747.GU11266@suse.de>
References: <20120907124232.GA11266@suse.de>
 <505AF81C.1080404@parallels.com>
 <20120920153705.GQ11266@suse.de>
 <505C306F.2000601@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <505C306F.2000601@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 01:16:31PM +0400, Glauber Costa wrote:
> On 09/20/2012 07:37 PM, Mel Gorman wrote:
> > On Thu, Sep 20, 2012 at 03:03:56PM +0400, Glauber Costa wrote:
> >> On 09/07/2012 04:42 PM, Mel Gorman wrote:
> >>> ./run-mmtests.sh test-run-1
> >>
> >> Mel, would you share with us the command line and config tweaks you had
> >> in place to run the memcg tests you presented in the memcg summit?
> >>
> > 
> > Apply the following patch to mmtests 0.05 and then from within the
> > mmtests directory do
> > 
> > ./run-mmtests.sh testrun
> > 
> > At the very least you should have oprofile installed. Optionally install
> > libnuma-devel but the test will cope if it's not available. Automatic package
> > installation will be in 0.06 for opensuse at least but other distros can
> > be easily supported if I know the names of the equivalent packages.
> > 
> > The above command will run both with and without profiling. The profiles
> > will be in work/log/pft-testrun/fine-profile-timer/base/ and an annotated
> > profile will be included in the file. If you have "recode" installed the
> > annotated profile will be compressed and can be extracted with something like
> > 
> > grep -A 9999999 "=== annotate ===" oprofile-compressed.report | grep -v annotate | recode /b64..char | gunzip -c
> > 
> > Each of the memcg functions will be small but when all the functions that
> > are in mm/memcontrol.c are added together it becomes a big problem.  What I
> > actually showed at the meeting was based on piping the oprofile report
> > through another quick and dirty script to match functions to filenames.
> > 
> > The bulk of this patch is renaming  profile-disabled-hooks-a.sh to
> > profile-hooks-a.sh. Let me know if you run into problems.
> 
> FYI: I get this:
> 
> Can't locate TLBC/Report.pm in @INC (@INC contains:
> /home/glauber/mmtests-0.05-mmtests-0.01/vmr/bin /usr/local/lib64/perl5
> /usr/local/share/perl5 /usr/lib64/perl5/vendor_perl
> /usr/share/perl5/vendor_perl /usr/lib64/perl5 /usr/share/perl5 .) at
> /home/glauber/mmtests-0.05-mmtests-0.01/vmr/bin/oprofile_map_events.pl
> line 11.
> 
> Investigating, it seems that hugetlbfs packages in fedora doesn't
> install any perl scripts, unlike SuSE.
> 

That is unexpected but thanks for pointing it out. I'll pull in the
necessary support files into mmtests itself to avoid the problem in the
future.

> I downloaded the library manually, and pointed perl path to it, and it
> seems to work.
> 

Good news, thanks.

-- 
Mel Gorman
SUSE Labs
