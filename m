Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab2IUJTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:19:53 -0400
Received: from mx2.parallels.com ([64.131.90.16]:43780 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757068Ab2IUJTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:19:52 -0400
Message-ID: <505C306F.2000601@parallels.com>
Date: Fri, 21 Sep 2012 13:16:31 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: MMTests 0.05
References: <20120907124232.GA11266@suse.de> <505AF81C.1080404@parallels.com> <20120920153705.GQ11266@suse.de>
In-Reply-To: <20120920153705.GQ11266@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 07:37 PM, Mel Gorman wrote:
> On Thu, Sep 20, 2012 at 03:03:56PM +0400, Glauber Costa wrote:
>> On 09/07/2012 04:42 PM, Mel Gorman wrote:
>>> ./run-mmtests.sh test-run-1
>>
>> Mel, would you share with us the command line and config tweaks you had
>> in place to run the memcg tests you presented in the memcg summit?
>>
> 
> Apply the following patch to mmtests 0.05 and then from within the
> mmtests directory do
> 
> ./run-mmtests.sh testrun
> 
> At the very least you should have oprofile installed. Optionally install
> libnuma-devel but the test will cope if it's not available. Automatic package
> installation will be in 0.06 for opensuse at least but other distros can
> be easily supported if I know the names of the equivalent packages.
> 
> The above command will run both with and without profiling. The profiles
> will be in work/log/pft-testrun/fine-profile-timer/base/ and an annotated
> profile will be included in the file. If you have "recode" installed the
> annotated profile will be compressed and can be extracted with something like
> 
> grep -A 9999999 "=== annotate ===" oprofile-compressed.report | grep -v annotate | recode /b64..char | gunzip -c
> 
> Each of the memcg functions will be small but when all the functions that
> are in mm/memcontrol.c are added together it becomes a big problem.  What I
> actually showed at the meeting was based on piping the oprofile report
> through another quick and dirty script to match functions to filenames.
> 
> The bulk of this patch is renaming  profile-disabled-hooks-a.sh to
> profile-hooks-a.sh. Let me know if you run into problems.

FYI: I get this:

Can't locate TLBC/Report.pm in @INC (@INC contains:
/home/glauber/mmtests-0.05-mmtests-0.01/vmr/bin /usr/local/lib64/perl5
/usr/local/share/perl5 /usr/lib64/perl5/vendor_perl
/usr/share/perl5/vendor_perl /usr/lib64/perl5 /usr/share/perl5 .) at
/home/glauber/mmtests-0.05-mmtests-0.01/vmr/bin/oprofile_map_events.pl
line 11.

Investigating, it seems that hugetlbfs packages in fedora doesn't
install any perl scripts, unlike SuSE.

I downloaded the library manually, and pointed perl path to it, and it
seems to work.

