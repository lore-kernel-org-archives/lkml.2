Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934734Ab0HNQyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 12:54:41 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:44246 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144Ab0HNQyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 12:54:40 -0400
Date: Sat, 14 Aug 2010 18:56:29 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Arthur Titeica <arthur@psw.ro>
Cc: Greg KH <gregkh@suse.de>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.35.2
Message-ID: <20100814165629.GA2170@osiris.boeblingen.de.ibm.com>
References: <20100813212313.GA22102@kroah.com>
 <a00737cba20cb46512a2248e0477cc0b@linux.psw.ro>
 <AANLkTi=YfKZkE6ee6rE9LvtAiQ6F0YaTHbN+O_dTGHKb@mail.gmail.com>
 <20100814133942.GA17430@suse.de>
 <59961099b1fbdb3e827d3c9f9bed3532@linux.psw.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59961099b1fbdb3e827d3c9f9bed3532@linux.psw.ro>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 05:08:54PM +0300, Arthur Titeica wrote:
> On Sat, 14 Aug 2010 06:39:42 -0700, Greg KH <gregkh@suse.de> wrote:
> > On Sat, Aug 14, 2010 at 02:21:31PM +0300, Pekka Enberg wrote:
> >> On Sat, Aug 14, 2010 at 1:35 PM, Arthur Titeica <arthur@psw.ro> wrote:
> >> > On Fri, 13 Aug 2010 14:23:13 -0700, Greg KH <gregkh@suse.de> wrote:
> >> >> I'm announcing the release of the 2.6.35.2 kernel.
> >> >>
> >> >> All users of the 2.6.35 kernel series must upgrade.
> >> >>
> >> >
> >> > I'm not sure this is the right mailing list but this is the first
> >> > kernel that fails to boot for me (since 2.6.33.x).
> >> >
> >> > The laptop just restarts right after "Freeing unused kernel memory:
> >> > 628k freed"
> >> >
> >> > 2.6.35.1 is fine with the same .config.
> >> >
> >> > Anyone willing to help me to debug?
> >>
> >> You could try 'git bisect' between v2.6.35.1 and v2.6.35.2 to narrow
> >> the problem down to a specific commit.
> > 
> > Yes, if you could please do that, it would be most appreciated.
> > 
> I'm trying but I'm not even close to a dev and anything beyond 'git
> pull' looks tricky.
> 
> I've gotten so far:
> 
> $ git bisect start
> $ git bisect bad
> $ git bisect good v2.6.35.1
> fatal: Needed a single revision
> Bad rev input: v2.6.35.1
> $ git bisect good v2.6.35
> Bisecting: 3941 revisions left to test after this (roughly 12 steps)
> [2192482ee5ce5d5d4a6cec0c351b2d3a744606eb] Merge branch 'for-rmk' of
> git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into
> devel-stable
> 
> What next? ;)

You are going to bisect the wrong tree. Looks like you don't have the
stable git tree:

# git clone --reference linux-2.6 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.35.y.git
# cd linux-2.6.35.y
# git bisect start
# git bisect good v2.6.35.1
# git bisect bad v2.6.35.2

'linux-2.6' would be your local clone of Linus' upstream git tree. That way
git will only pull a couple of megs instead of several hundred megs.
