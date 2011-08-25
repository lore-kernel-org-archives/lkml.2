Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1HYRND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:13:03 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:42397 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750725Ab1HYRNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:13:00 -0400
Date: Thu, 25 Aug 2011 10:12:55 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Johannes Weiner <jweiner@redhat.com>, quilt-dev@nongnu.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Hocko <mhocko@suse.cz>,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: mmotm 2011-08-24-14-08 uploaded
Message-Id: <20110825101255.15436784.rdunlap@xenotime.net>
In-Reply-To: <20110825154538.GA5860@redhat.com>
References: <201108242148.p7OLm1lt009191@imap1.linux-foundation.org>
	<20110825135103.GA6431@tiehlicka.suse.cz>
	<20110825140701.GA6838@tiehlicka.suse.cz>
	<20110826010938.5795e43137d58c9f42d44458@canb.auug.org.au>
	<20110825154538.GA5860@redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 17:45:38 +0200 Johannes Weiner wrote:

> On Fri, Aug 26, 2011 at 01:09:38AM +1000, Stephen Rothwell wrote:
> > Hi,
> > 
> > On Thu, 25 Aug 2011 16:07:01 +0200 Michal Hocko <mhocko@suse.cz> wrote:
> > >
> > > On Thu 25-08-11 15:51:03, Michal Hocko wrote:
> > > > 
> > > > On Wed 24-08-11 14:09:05, Andrew Morton wrote:
> > > > > The mm-of-the-moment snapshot 2011-08-24-14-08 has been uploaded to
> > > > > 
> > > > >    http://userweb.kernel.org/~akpm/mmotm/
> > > > 
> > > > I have just downloaded your tree and cannot quilt it up. I am getting:
> > > > [...]
> > > > patching file tools/power/cpupower/debug/x86_64/centrino-decode.c
> > > > Hunk #1 FAILED at 1.
> > > > File tools/power/cpupower/debug/x86_64/centrino-decode.c is not empty after patch, as expected
> > > > 1 out of 1 hunk FAILED -- rejects in file tools/power/cpupower/debug/x86_64/centrino-decode.c
> > > > patching file tools/power/cpupower/debug/x86_64/powernow-k8-decode.c
> > > > Hunk #1 FAILED at 1.
> > > > File tools/power/cpupower/debug/x86_64/powernow-k8-decode.c is not empty after patch, as expected
> > > > 1 out of 1 hunk FAILED -- rejects in file tools/power/cpupower/debug/x86_64/powernow-k8-decode.c
> > > > [...]
> > > > patching file virt/kvm/iommu.c
> > > > Patch linux-next.patch does not apply (enforce with -f)
> > > > 
> > > > Is this a patch (I am using 2.6.1) issue? The failing hunk looks as
> > > > follows:
> > > > --- a/tools/power/cpupower/debug/x86_64/centrino-decode.c
> > > > +++ /dev/null
> > > > @@ -1 +0,0 @@
> > > > -../i386/centrino-decode.c
> > > > \ No newline at end of file
> > > 
> > > Isn't this just a special form of git (clever) diff to spare some lines
> > > when the file deleted? Or is the patch simply corrupted?
> > > Anyway, my patch doesn't cope with that. Any hint what to do about it?
> > 
> > Those files were symlinks and were removed by a commit in linux-next.
> > diff/patch does not cope with that.
> 
> You can probably replace `patch' in your $PATH by a wrapper that uses
> git-apply, which can deal with them.
> 
> Or you could use git-quiltimport, which uses git-apply, to prepare the
> -mmotm base tree in git, on top of which you can continue to work with
> quilt.
> 
> I do this with a cron-job automatically, you can find the result here:
> 
>     http://git.kernel.org/?p=linux/kernel/git/hannes/linux-mmotm.git;a=summary
> 
> If you want to do it manually, there is sometimes confusing binary
> file patch sections in -mmotm, which in turn git-apply can not deal
> with, so I use the following uncrapdiff.awk filter on the patches
> before import.


I thought that I recently saw a reference to an unreleased version of quilt
that handles git symlinks.  Was I dreaming?
or where is it?

Thanks.

> ---
> 
> # Filter out sections that feature an index line but
> # no real diff part that would start with '--- file'
> 
> {
> 	if (HEADER ~ /^diff --git /) {
> 		if ($0 ~ /^index /) {
> 			INDEX=$0
> 		} else if ($0 ~ /^diff --git /) {
> 			print(HEADER)
> 			HEADER=$0
> 		} else if (INDEX ~ /^index /) {
> 			if ($0 ~ /^--- /) {
> 				print(HEADER)
> 				print(INDEX)
> 				print($0)
> 			}
> 			HEADER=""
> 			INDEX=""
> 		} else {
> 			HEADER=HEADER "\n" $0
> 		}
> 	} else if ($0 ~ /^diff --git /) {
> 		HEADER=$0
> 	} else {
> 		print($0)
> 	}
> }
> 
> ---

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
