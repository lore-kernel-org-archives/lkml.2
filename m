Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0KHSWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:22:36 -0500
Received: from pqueueb.post.tele.dk ([193.162.153.10]:38323 "EHLO
	pqueueb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab0KHSWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:22:35 -0500
Date: Mon, 8 Nov 2010 19:22:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Christoph Egger <siccegge@cs.fau.de>, linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: fstat suddenly return -EINVAL [Was: Bus error on make
	allyesconfig, kernelbuild with HEAD]
Message-ID: <20101108182209.GA26742@merkur.ravnborg.org>
References: <87d3qicwxn.fsf@gmail.com> <87aalmcv0p.fsf@gmail.com> <20101106162426.GA14361@merkur.ravnborg.org> <87tyjtjd7m.fsf@gmail.com> <20101107170700.GA22684@merkur.ravnborg.org> <87mxplypid.fsf@gmail.com> <20101107223056.GA23871@merkur.ravnborg.org> <87lj54raw3.fsf@gmail.com> <20101108101920.GA5527@cr0.nay.redhat.com> <87d3qgq9ca.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87d3qgq9ca.fsf@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 07:38:13AM -0500, Ben Gamari wrote:
> On Mon, 8 Nov 2010 18:20:02 +0800, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> > But fixdep should be compiled by the host compiler...
> > 
> Very good point.
> 
> > So, does this error also occur when you do non-cross compiling on the
> > same partition?
> > 
> Hmm, it seems to be fine when not cross-compiling. Interesting.
> 
> > Thanks for your testing!
> 
> No worries!

Hi Ben - interesting information.

Do you see that this bug trigger for the same file always?
You could try to print out the filename if fstat fails.

If this happens while accessing the same file then try to
check if this file has any special permissions / security settings.
[I looked a bit on the kernel side of fstat() and it looked
like a security check could result in EINVAL].

Again if it is always the same file try if you can read it
using less/vi.

>From your previous posting it looks like you have some special setting
that impact your choice of HOST gcc.
Do you define HOSTCC somewhere?


	Sam
