Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0KGRHF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 12:07:05 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:60790 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab0KGRHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 12:07:03 -0500
Date: Sun, 7 Nov 2010 18:07:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Christoph Egger <siccegge@cs.fau.de>, linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: Bus error on make allyesconfig, kernelbuild with HEAD
Message-ID: <20101107170700.GA22684@merkur.ravnborg.org>
References: <20100729105225.GA13192@faui48a.informatik.uni-erlangen.de> <AANLkTi=cYgV69VyNZ+TKs_f-+3AJmyo_RaYS57R72j50@mail.gmail.com> <20100729121002.GC13192@faui48a.informatik.uni-erlangen.de> <20100730084353.GB5638@cr0.nay.redhat.com> <87d3qicwxn.fsf@gmail.com> <87aalmcv0p.fsf@gmail.com> <20101106162426.GA14361@merkur.ravnborg.org> <87tyjtjd7m.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87tyjtjd7m.fsf@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 11:44:13AM -0500, Ben Gamari wrote:
> On Sat, 6 Nov 2010 17:24:26 +0100, Sam Ravnborg <sam@ravnborg.org> wrote:
> > Took a quick look.
> > Does the following patch fix it?
> > 
> > if m == p then we will stay in the while look looking for a space.
> > I did not audit all of the code - there may be other issues..
> > 
> P.S. Sorry for the noise
> 
> Looks like something very odd is happening here. Seems like stat is
> giving us the wrong size. As seen below, ls reports the file size to be
> 5247 whereas st.stat indicates a size substantially larger than
> that. Output from make with attached patch applied:
> 
> $ ls -l scripts/basic/.fixdep.d
> -rw-r--r-- 1 bgamari bgamari 5247 2010-11-07 11:35 scripts/basic/.fixdep.d
> $ make V=1
> In file included from /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/stdlib.h:903,
>                  from scripts/basic/fixdep.c:112:
> /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/stdlib.h:65: warning: no previous prototype for ‘ptsname_r’
> file=scripts/basic/.fixdep.d
> st.size=2ad5f6cecb36

Interesting and valueable information!

Looks like fstat() failed for some odd reason
Could you try to check the return value of fstat().

If it retruns less than 0 then print out errno (preferable using perror()).

	Sam
