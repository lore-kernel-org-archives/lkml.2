Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab2BOHm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 02:42:29 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33525 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625Ab2BOHm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 02:42:28 -0500
Date: Wed, 15 Feb 2012 11:42:24 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [patch 0/4] Resending, c/r series v2
Message-ID: <20120215074224.GB4533@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3B3A14.7000305@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 08:52:36AM +0400, Pavel Emelyanov wrote:
> On 02/15/2012 02:51 AM, Andrew Morton wrote:
> > On Mon, 13 Feb 2012 20:48:22 +0400
> > Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > 
> >> Hi, this series hopefully in a good shape
> >>
> >>  - sys_kcmp now depends on CONFIG_CHECKPOINT_RESTORE
> >>
> >>  - the extension of /proc/pid/stat now done against
> >>    linux-next/master
> >>
> >> Please letme know if I've missed something.
> > 
> > Thus far our (my) approach has been to trickle the c/r support code
> > into mainline as it is developed.  Under the assumption that the end
> > result will be acceptable and useful kernel code.
> > 
> > I'm afraid that I'm losing confidence in that approach.  We have this
> > patchset, we have Stanislav's "IPC: checkpoint/restore in userspace
> > enhancements" (which apparently needs to get more complex to support
> > LSM context c/r).  I simply *don't know* what additional patchsets are
> > expected.  And from what you told me it sounds like networking support
> > is at a very early stage and I fear for what the end result of that
> > will look like.
> 
> I understand. But there was a confidence that nobody wanted the c/r stuff to 
> be the "one big kernel subsystem", but it should rather be "a bunch of small 
> API-s for what is required". The amount of code for the initial C/R attempt was
> ~100 patches. The amount of code to support our user-space C/R implementation
> *only* is ~10 and the feature-set of both is already comparable.
> 

Andrew, I hope Pavel has addressed all your concerns? What I personally
trying to achieve mostly -- the patches should be as minimum as possible,
still usable. I believe the patches which are already in tree are useful for
other projects as well (for example -- /proc/pid/task/tid/"children" to find
all children and build process topology fast). prctl extension look a bit
redundant for kernel in general, but they are easily turnable off via Kconfig
option. /proc/pid/map_files/ might be redundant too but it could be eliminated
via Kconfig as well. So I think the both series actually do not bring much noise
into kernel itself.

	Cyrill
