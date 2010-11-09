Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab0KIC0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 21:26:33 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50942 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab0KIC0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 21:26:31 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [resend][PATCH 2/4] Revert "oom: deprecate oom_adj tunable"
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1011011232120.6822@chino.kir.corp.google.com>
References: <20101101030353.607A.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011011232120.6822@chino.kir.corp.google.com>
Message-Id: <20101109105801.BC30.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 11:26:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 1 Nov 2010, KOSAKI Motohiro wrote:
> 
> > > The new tunable added in 2.6.36, /proc/pid/oom_score_adj, is necessary for 
> > > the units that the badness score now uses.  We need a tunable with a much 
> > 
> > Who we?
> > 
> 
> Linux users who care about prioritizing tasks for oom kill with a tunable 
> that (1) has a unit, (2) has a higher resolution, and (3) is linear and 
> not exponential.  

No. Majority user don't care. You only talk about your case. Don't ignore
end user.


> Memcg doesn't solve this issue without incurring a 1% 
> memory cost.

Look at a real.
All major distributions has already turn on memcg. End user don't need
to pay additional cost.



> 
> > > higher resolution than the oom_adj scale from -16 to +15, and one that 
> > > scales linearly as opposed to exponentially.  Since that tunable is much 
> > > more powerful than the oom_adj implementation, which never made any real 
> > 
> > The reason that you ware NAKed was not to introduce new powerful feature.
> > It was caused to break old and used feature from applications.
> > 
> 
> No, it doesn't, and you completely and utterly failed to show a single 
> usecase that broke as a result of this because nobody can currently use 
> oom_adj for anything other than polarization.  Thus, there's no backwards 
> compatibility issue.

No. I showed. 
1) Google code search showed some application are using this feature.
	http://www.google.com/codesearch?as_q=oom_adj&btnG=Search+Code&hl=ja&as_package=&as_lang=&as_filename=&as_class=&as_function=&as_license=&as_case=

2) Not body use oom_adj other than polarization even though there are a few.
   example, kde are using.
	http://www.google.com/codesearch/p?hl=ja#MPJuLvSvNYM/pub/kde/unstable/snapshots/kdelibs.tar.bz2%7CWClmGVN5niU/kdelibs-1164923/kinit/start_kdeinit.c&q=oom_adj%20kde%205

When you are talking polarization issue, you blind a real. Don't talk your dream.

3) udev are using this feature. It's one of major linux component and you broke.

http://www.google.com/codesearch/p?hl=ja#KVTjzuVpblQ/pub/linux/utils/kernel/hotplug/udev-072.tar.bz2%7CwUSE-Ay3lLI/udev-072/udevd.c&q=oom_adj

You don't have to break our userland. you can't rewrite or deprecate 
old one. It's used! You can only add orthogonal new knob.


> > > sense for defining oom killing priority for any purpose other than 
> > > polarization, the old tunable is deprecated for two years.
> > 
> > You haven't tested your patch at all. Distro's initram script are using
> > oom_adj interface and latest kernel show pointless warnings 
> > "/proc/xx/oom_adj is deprecated, please use /proc/xx/oom_score_adj instead."
> > at _every_ boot time.
> > 
> 
> Yes, I've tested it, and it deprecates the tunable as expected.  A single 
> warning message serves the purpose well: let users know one time without 
> being overly verbose that the tunable is deprecated and give them 
> sufficient time (2 years) to start using the new tunable.  That's how 
> deprecation is done.

no sense.

Why do their application need to rewrite for *YOU*? Okey, you will got
benefit from your new knob. But NOBDOY use the new one. and People need
to rewrite their application even though no benefit. 

Don't do selfish userland breakage!



