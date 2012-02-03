Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab2BCHS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:18:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62845 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2BCHSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:18:24 -0500
Date: Fri, 3 Feb 2012 11:18:19 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [patch cr 4/4] c/r: prctl: Extend PR_SET_MM to set up more
 mm_struct entries
Message-ID: <20120203071819.GC1968@moon>
References: <20120130140905.441199885@openvz.org>
 <20120130141852.466613862@openvz.org>
 <20120202152705.831b00c7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202152705.831b00c7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 03:27:05PM -0800, Andrew Morton wrote:
> On Mon, 30 Jan 2012 18:09:09 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > After restore we would like the 'ps' command show the command
> > line and evironment exactly the same it was at checkpoint time.
> > 
> > So this additional PR_SET_MM_ allow us to do so. Note that
> > these members of mm_struct is rather used for output in
> > procfs, except auxv vector which is used by ld.so mostly.
> 
> This changelog is pretty darned hard to understand.  Can we have a
> version 2 please?
> 

yeah, will update.
...
> > @@ -1790,16 +1779,53 @@ static int prctl_set_mm(int opt, unsigne
> >  		mm->brk = addr;
> >  		break;
> 
> Here would be a good place to add some nice comments explaining what
> these do.  Although I guess that isn't needed if one can get that info
> by typing "man prctl".
> 

I started cooking prctl man pages but found hardness to explain some
regular user who has no ideas about kernel internals why do we modify
mm_struct data, still I'm trying.

And I'll add comment here (since having it here in-place allows reader
to not read man page ;)
...
> 
> I worry a bit about this.  We're giving userspace the ability to modify
> various mm_struct fields.  Userspace can already do this via
> exec(elf-file), but perhaps this opens up a way in which userspace can
> newly trigger kernel bugs.
> 

At moment there is no more way to modify these fields other than elf
handler, but in future... hard to predict what else there will be
done and where also these fields appear in kernel code. but as i said
at moment this modification is pretty safe and even if one write some
buggy values -- he simply get weird output in /proc/ statistics and
such.

	Cyrill
