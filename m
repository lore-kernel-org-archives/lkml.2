Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab0KGWbA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 17:31:00 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:53769 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0KGWa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 17:30:58 -0500
Date: Sun, 7 Nov 2010 23:30:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Christoph Egger <siccegge@cs.fau.de>, linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: fstat suddenly return -EINVAL [Was: Bus error on make
	allyesconfig, kernelbuild with HEAD]
Message-ID: <20101107223056.GA23871@merkur.ravnborg.org>
References: <20100729105225.GA13192@faui48a.informatik.uni-erlangen.de> <AANLkTi=cYgV69VyNZ+TKs_f-+3AJmyo_RaYS57R72j50@mail.gmail.com> <20100729121002.GC13192@faui48a.informatik.uni-erlangen.de> <20100730084353.GB5638@cr0.nay.redhat.com> <87d3qicwxn.fsf@gmail.com> <87aalmcv0p.fsf@gmail.com> <20101106162426.GA14361@merkur.ravnborg.org> <87tyjtjd7m.fsf@gmail.com> <20101107170700.GA22684@merkur.ravnborg.org> <87mxplypid.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mxplypid.fsf@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben.

[Context to new readers: Ben experience that fixdep (part of kbuild)
 exists with an error during kernel compilations.
 This is now tracked down to fstat() returning EINVAL.
 Due to missing error checks in fixdep.c this has been a long journey
 to reach this far. ]

I looked briefly at the fstat implmnetation in the kernel and
this did not give me any hints.
I therefore changed to subject to attrack attention of more readers.

Can you supply us with a bit more information about your system:
- filesystem (as fstat seems to reach filesystem specific code)
- glibc version 
- box (architecture + 32 or 64 bit kernel)
- do you see other things misbehave or is this only a kernel build thing

If you have provided this info in the past I have missed it.

	Sam

[Kept the below for new readers]

On Sun, Nov 07, 2010 at 01:09:30PM -0500, Ben Gamari wrote:
> On Sun, 7 Nov 2010 18:07:00 +0100, Sam Ravnborg <sam@ravnborg.org> wrote:
> > Interesting and valueable information!
> > 
> > Looks like fstat() failed for some odd reason
> > Could you try to check the return value of fstat().
> > 
> fixdep: fstat failed: Invalid argument
> 
> Interesting indeed. According to my manpage fstat doesn't even return
> EINVAL.
> 
> - Ben
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
