Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab1G2VcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 17:32:11 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:48246 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab1G2VcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 17:32:10 -0400
Date: Fri, 29 Jul 2011 23:31:56 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Luke Kenneth Casson Leighton <lkcl@lkcl.net>, linux-kernel@vger.kernel.org
Subject: Re: ext3 hacked filesystem (by debian exim4 exploit) available for
 analysis and bugreporting
Message-ID: <20110729213156.GA32685@citd.de>
References: <CAPweEDzv+vByC1s2bWRjVQdVLqw4Xf2sUf_CQgVync_YcxtdvQ@mail.gmail.com>
 <20110725134533.GA23781@citd.de>
 <CAPweEDybuOpPVidJWg+rfs8rU8y=xo4d3H=P7XQJh_DiKrF4DQ@mail.gmail.com>
 <20110729195904.GC1720@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110729195904.GC1720@ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.07.2011 21:59, Pavel Machek wrote:
> On Mon 2011-07-25 22:08:24, Luke Kenneth Casson Leighton wrote:
> > On Mon, Jul 25, 2011 at 2:45 PM, Matthias Schniedermeyer <ms@citd.de> wrote:
> > > On 25.07.2011 13:08, Luke Kenneth Casson Leighton wrote:
> > >> folks, hi,
> > >>
> > >> apart from anything, files which cannot be deleted (and cannot be
> > >> detected as "corrupted" by fsck.ext3) is pretty damn serious.
> > >
> > > You did try lsattr and checked that the files aren't 'immutable'?
> > 
> >  i didn't! :)  didn't know about (but should have guessed) ext3
> > attributes.  they are indeed - thank you matthias.
> > 
> > root@quietbaby:/mnt/horsebox/tmp3# lsattr *
> > ----ia------------- bin3/kill
> > ----ia------------- bin3/ps
> > ----ia------------- c.pl
> > ----ia------------- e.conf
> > ----ia------------- sbin3/sysctl
> > ----ia------------- usrbin3/uptime
> > ----ia------------- usrbin3/tload
> > ----ia------------- usrbin3/free
> > ----ia------------- usrbin3/top
> > ----ia------------- usrbin3/vmstat
> > ----ia------------- usrbin3/watch
> > ----ia------------- usrbin3/skill
> > ----ia------------- usrbin3/pmap
> > ----ia------------- usrbin3/pgrep
> > ----ia------------- usrbin3/slabtop
> > ----ia------------- usrbin3/pwdx
> > ----ia------------- usrbin3/snice
> > ----ia------------- usrbin3/pkill
> > ----ia------------- usrbin3/w
> > 
> > so - looks like it's not as bad as i thought.
> 
> Should ls -l be moddified to show something when file has immutable
> (and friends) set?

AFAICT lsattr, in e2fsprogs, only does a 'stat'(lib/e2p/fgetflags.c) and 
checks st_flags, which i can't see in the "man 2 stat"-man-page i have 
installed, but nonetheless that is what it appears to do.

So assuming there are no incompatibilites between filesystems, the 
information appears to come "free" with the stat(s) that ls has to do 
anyway. (In the sense that there doesn't appear to any excessive 
overhead involved, especially no additional I/O).

So i would say: definitly.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

