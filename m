Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab2BDNJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 08:09:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53260 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab2BDNJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 08:09:19 -0500
Date: Sat, 4 Feb 2012 14:08:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] SubmittingPatches: Increase the line length limit from
 80 to 100 colums
Message-ID: <20120204130859.GB30198@elte.hu>
References: <20120130140905.441199885@openvz.org>
 <20120130141852.309402052@openvz.org>
 <20120203074656.GC30543@elte.hu>
 <20120203083530.GD1968@moon>
 <20120203090929.GA23996@elte.hu>
 <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
 <20120203095227.GA13162@elte.hu>
 <20120203100743.GA3334@elte.hu>
 <20120203125715.0e9dfb1d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203125715.0e9dfb1d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 3 Feb 2012 11:07:43 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > [PATCH] SubmittingPatches: Increase the line length limit from 80 to 100 colums
> > 
> > The overwhelming majority of kernel developers have stopped 
> > using 80 col terminals years ago.
> > 
> > As far as I'm aware I was the last regular kernel 
> > contributor who still used a standard VGA text console, but 
> > both text consoles and using them to read the kernel source 
> > code has become increasingly gruesome years ago so I 
> > switched to a wider terminal two years ago.
> 
> I always use 80-cols, everywhere.  Not because I particularly 
> like it - I find it a bit too small.  I use it because it is 
> the standard, and using it helps me see where and how badly we 
> violate the standard.
> 
> We've actually done pretty well - linewrap in 80 cols rarely 
> causes me problems.  It's sufficiently rare that when it 
> *does* happen, it really stands out.

Maybe it got better after the introduction of checkpatch - I 
stopped using 80col terminals because the situation *was* 
getting so bad and because i did not feel like fighting a 
thousand other kernel developers who had different preferences 
;-)

> IOW, the changelog is quite the exaggeration.

You are right about that.

> > So lets increase the limit to 100 cols
> 
> I think that's going too far - 96 will be enough and it's a 
> multiple of 8.
> 
> The multiple-of-8 thing seems pleasing but probably doesn't 
> matter much.  It means that things like
> 
> 
> if (foo) {
> 	if (foo) {
> 		if (foo) {
> 			if (foo) {
> 				if (foo) {
> 					if (foo) {
> 						if (foo) {
> 							if (foo) {
> 								if (foo) {
> 									if (foo) {
> 										if (foo) {
> 											if (foo) {
> 												if (foo) {
> 													if (foo) {
> 														if (foo) {
> 												
> 
> will line up properly.
> 
> If we really want to improve the world we should jump into a 
> time machine and set tabstops to 4.  Sigh.

I think that would be a distinctly bad decision - people could 
have crazy, 10 levels nesting in a function and be technically 
'compliant'.

8 col tabs _forces clean code_ more often than not. I know about 
very few functions in the kernel that legitimately need more 
than 3 or 4 levels of nesting.

And that is why I agree with the 6-tab based warning approach - 
then we can remove the 80col warning which is really making 
things actively worse.

Thanks,

	Ingo
