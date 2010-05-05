Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab0EEH0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 03:26:11 -0400
Received: from smtp.nokia.com ([192.100.122.230]:54349 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab0EEH0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 03:26:09 -0400
Subject: Re: [PULL] param sysfs oops (simple, leaky) fix, bool arrays fix
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>
In-Reply-To: <201005051503.42289.rusty@rustcorp.com.au>
References: <200910290902.13724.rusty@rustcorp.com.au>
	 <201005041154.24658.rusty@rustcorp.com.au>
	 <1272996439.2458.0.camel@localhost.localdomain>
	 <201005051503.42289.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 10:25:14 +0300
Message-ID: <1273044314.3702.98.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 May 2010 07:25:33.0330 (UTC) FILETIME=[25F56F20:01CAEC24]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 15:03 +0930, Rusty Russell wrote:
> On Wed, 5 May 2010 03:37:19 am Artem Bityutskiy wrote:
> > On Tue, 2010-05-04 at 11:53 +0930, Rusty Russell wrote:
> > > On Tue, 27 Apr 2010 08:23:24 pm Artem Bityutskiy wrote:
> > > > Rusty, correct me if I'm wrong, but it looks like the above memleak was
> > > > introduced by e180a6b7759a99a28cbcce3547c4c80822cb6c2a, where you added
> > > > the kstrdup(). So you kinda fixed the sysfs case (it still memleaks
> > > > though), but at the cost of additional insmod/rmmod leak, right?
> > > 
> > > Yep!
> > 
> > Are you working/planning to work on fixing this regression?
> 
> I'm still ambivalent on it; I have patches but it's a lot of churn for not
> much gain.
> 
> To fix this, we need a way to lock parameters against changing by sysfs, and
> we need to use it everywhere.  Past experience has demonstrated that this will
> never be maintained.  
> 
> On the other hand, the leak is trivial.

Well, I am not very concerned with the "changing by sysfs" leak. This is
not a big deal, IMHO. I am concerned with the "rmmod" leak, which did
not exist before your patches, but exists now. People may do a lot of
insmod/rmmod, and on each rmmod they will loose this kstrdup-ed string. 

I'll take a look at this tree, thank you.

> Here's a git tree if you want to look further:
> 
> The following changes since commit 05ce7bfe547c9fa967d9cab6c37867a9cb6fb3fa:
>   Linus Torvalds (1):
>         Merge branch 'for_linus' of git://git.kernel.org/.../jack/linux-fs-2.6
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/rusty/linux-2.6-param-fixes.git master

Just in case others will clone, the correct URL seems to be

git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-param-fixes.git master

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

