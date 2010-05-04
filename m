Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab0EDAuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 20:50:50 -0400
Received: from p01c12o141.mxlogic.net ([208.65.145.64]:47920 "EHLO
	p01c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab0EDAut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 20:50:49 -0400
X-MXL-Hash: 4bdf6f695348f3e8-666e8c06632744882c81b7f9e365d4e23862ddec
X-MXL-Hash: 4bdf6f5214556c6e-3a352482b01e4c338f2357db03d12e93c653bceb
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@suse.de>
CC: Greg KH <greg@kroah.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 3 May 2010 19:49:33 -0500
Subject: RE: Staging: dt3155: Cleanup memory mapped i/o access
Thread-Topic: Staging: dt3155: Cleanup memory mapped i/o access
Thread-Index: AcrrGkrEH0NQFeb3S5mlwvYy0DqGnQAByHjw
Message-ID: <0D753D10438DA54287A00B0270842697636EADE2CE@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636DAFCD14@AUSP01VMBX24.collaborationhost.net>
 <20100430215645.GA12409@kroah.com>
 <0D753D10438DA54287A00B0270842697636E9B9B0D@AUSP01VMBX24.collaborationhost.net>
 <20100503185933.GA27346@kroah.com>
 <0D753D10438DA54287A00B0270842697636EADDEC0@AUSP01VMBX24.collaborationhost.net>
 <20100503211751.GB21402@kroah.com>
 <0D753D10438DA54287A00B0270842697636EADE1D2@AUSP01VMBX24.collaborationhost.net>
 <0D753D10438DA54287A00B0270842697636EADE26A@AUSP01VMBX24.collaborationhost.net>
 <20100503234123.GC13519@suse.de>
In-Reply-To: <20100503234123.GC13519@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010043001)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.180]
X-AnalysisOut: [v=1.0 c=1 a=n2LqRRw_DHMA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=38uLcFpo6nJaFUi5eYvXHw==:17 a=VwQbUJbxAAAA:8 a=L2y]
X-AnalysisOut: [ygu3JOyMkeqoCsSYA:9 a=MEoI34jXCXCMQR2vZrsA:7 a=q_6cNYujlvV]
X-AnalysisOut: [Y5gYdQi5SyHKsveoA:4 a=CjuIK1q_8ugA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 03, 2010 4:41 PM, Greg KH wrote:
> On Mon, May 03, 2010 at 06:33:08PM -0500, H Hartley Sweeten wrote:
>> It appears these are the patches missing in your staging-next tree that do
>> exist in the linux-next tree:
>> 
>> Staging: dt3155: remove "inline" usage
>> Staging: dt3155: rename dt3155_fbuffer_s
>> Staging: dt3155: rename dt3155_config_s
>> Staging: dt3155: rename dt3155_read_t
>> Staging: dt3155: rename dt3155_status_t
>> Staging: dt3155: remove frame_info_t
>> Staging: dt3155: remove TRUE/FALSE
>> Staging: dt3155: remove #ifdef
>> Staging: dt3155: allocator.c: sparse cleanups
>> Staging: dt3155: fix parentheses and bracket spacing style issues
>> Staging: dt3155: fix coding style issue in dt3155_isr.c
>> Staging: dt3155: fix wait_ibsyclr function
>> Staging: remove unused #include <linux/version.h>
>
> No, wait, I see these in my staging-next tree here.  Some of them I
> wrote :)
>
> Are you sure you are cloning my tree properly?

OK. I cloned your tree a different way this time.  This time I did:

$ git clone --reference ../linux-2.6 staging-2.6
Initialized empty Git repository in /home/bigguiness/src/git/z/staging-2.6/.git/
warning: You appear to have cloned an empty repository.
$ cd staging-2.6
$ git remote add staging-2.6 git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
$ git fetch staging-2.6
remote: Counting objects: 1541325, done.
remote: Compressing objects: 100% (249801/249801), done.
remote: Total 1541325 (delta 1283336), reused 1536966 (delta 1279192)
Receiving objects: 100% (1541325/1541325), 342.86 MiB | 330 KiB/s, done.
Resolving deltas: 100% (1283336/1283336), done.
>From git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6
 * [new branch]      master     -> staging-2.6/master
 * [new branch]      staging-next -> staging-2.6/staging-next
 ...
$ git branch -a
  remotes/staging-2.6/master
  remotes/staging-2.6/staging-next
$ git checkout remotes/staging-2.6/staging-next
Checking out files: 100% (32340/32340), done.
Note: checking out 'remotes/staging-2.6/staging-next'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b new_branch_name

HEAD is now at e595eea... Staging: comedi: __user markup on comedi_fops.c


Now it's different.  Your staging-next tree appears to be missing these patches:

Staging: dt3155: fix 50Hz configuration
staging: fix dt3155 build

Both of which change dt3155_drv.c and both of which are in Linus' tree
and the next tree.

I think this explains why you had issues with trying to merge my patch
with the dt3155_drv.c file.  But it still doesn't explain the problem
with dt3155_io.c.  All the files except dt3155_drv.c seem to match
between next-20100503 and your staging-next tree.

Argh!  git drives me nuts sometimes....

Regards,
Hartley
