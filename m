Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846Ab2CMG0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:26:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52090 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759828Ab2CMG0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:26:30 -0400
Date: Tue, 13 Mar 2012 10:26:25 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120313062625.GA1912@moon>
References: <20120309141349.GC13346@moon>
 <20120309142620.GA5334@redhat.com>
 <20120309144239.GD13346@moon>
 <20120309152122.GA7802@redhat.com>
 <20120309154224.GE13346@moon>
 <20120309220244.GD19584@count0.beaverton.ibm.com>
 <20120309223932.GB725@moon>
 <20120309235901.GE19584@count0.beaverton.ibm.com>
 <20120310074854.GA3065@moon>
 <20120313024511.GF19584@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313024511.GF19584@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 07:45:11PM -0700, Matt Helsley wrote:
> > 
> > Indeed. But I think any change will mean compatibility broken, programs
> > may rely on one-shot or multi-shot behaviour. So I personally vote
> > for more flexible approach here.
> 
> Very true. In fact thinking about this prctl a bit more makes me more certain
> that one-shot is better and it ought to stay that way forever. The
> flexibility to change the /proc/pid/exe symlink could be yet another
> way for malicious code to obscure a compromised program and
> masquerade as a benign process. That's a problem inherent in this prctl
> whether its one-shot or multi-shot. However, if you use the one-shot
> approach then a security-concious program can use this prctl once
> during its early initialization to ensure the prctl cannot later be abused
> for this purpose.
> 

Hi Matt,

well, sure our tool can live with one-shot approach (and I'll update it)
but not that only program with CAP_RESOURCE granted can do that, ie it's
not any arbitrary program in a system.

> > names -- how would he know if a program did change own /proc/pid/exe
> > at all? Note it's not that important how many times the symlink was
> > changed there is simply no way to find out if it was changed at all,
> > and actually from my POV it's a win for transparent c/r, that was
> > all the idea.
> 
> I am quite aware of the c/r use for this prctl :). However I also
> wonder if there aren't serious malicious uses of it. I'm not saying the
> symlink has to be perfectly accurate at all times,  but it's easy and
> reasonable to make it much harder to abuse this particular prctl for
> malicious purposes by making it one-shot.
> 

ok, convinced, I'll update the patch ;)

> With this patch -- especially the multi-shot form -- the symlink will
> be entirely under the control of (potentially untrusted) userspace code
> and the admin is totally at the mercy of the userspace code. In
> single-shot form programs could use the prctl() to ensure the symlink
> could not be changed later -- the restart tool would be the only program
> that would need to ensure that prctl() had not been used since the last
> exec*().
> 
> If we're going to let userspace do arbitrary things to the symlink I can't
> help but wonder why we can't skip the prctl() altogether and just enable
> MAP_EXECUTABLE in mmap().

Well, hard to tell from my side. At moment I don't see problem in allowing
MAP_EXECUTABLE in mmap, but -mm guys help needed. I'm sure there were a reason
why it's not allowed.

	Cyrill
