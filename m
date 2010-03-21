Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab0CUTOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 15:14:21 -0400
Received: from bar.sig21.net ([80.81.252.164]:33591 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab0CUTOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 15:14:19 -0400
Date: Sun, 21 Mar 2010 20:16:19 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Valery Reznic <valery_reznic@yahoo.com>
Cc: David Newall <davidn@davidnewall.com>, linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org
Subject: Re: execve for script don't return ENOEXEC, bug ?
Message-ID: <20100321191619.GA5235@sig21.net>
References: <4BA50C76.9070603@davidnewall.com>
 <876436.86374.qm@web110307.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <876436.86374.qm@web110307.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.781,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc: man page maintainer)

On Sun, Mar 21, 2010 at 01:33:28AM -0700, Valery Reznic wrote:
> --- On Sat, 3/20/10, David Newall <davidn@davidnewall.com> wrote:
> > Valery Reznic wrote:
> > > execve's man page state that script's interprtert
> > > should not be interpreter itself:
...
> > > To me it looks like  execve and it's man page
> > > disagree. Do you know is it new intended behaviour of execve
> > > and just man page wasn't update or it's a bug in execve ?
> > 
> > Code and man pages do sometimes disagree.  I shan't
> > address what the correct behaviour is, because if you ask
> > three people you're sure to get four different answers,
> > rather let's discuss what is desirable.  Without
> > looking at how it works, we observe that a.sh can be
> > executed without error.  If a.out were written in C it
> > would qualify as an acceptable interpreter according to the
> > man page, so why should it not qualify if it is
> > interpreted?  I think it's desirable that it does
> > qualify.  There could be sound reasons why only one
> > level of interpreter can be invoked.  Perhaps loading a
> > script interpreter is done as an exception in exec, and it's
> > too ugly to allow recursive exceptions.  That would be
> > a fair reason.  But if there's no reason, then don't
> > have the restriction*.  Linux now apparently does
> > permit interpreted interpreters, and I say that is the
> > desirable result.
> For some reason I tough that ENOEXEC for 'interpreted interpreter' is posix
> requirement. But after closer look it appear to be only arbitrary restriction
> now lifted in Linux.
> 
> I had a look at the source http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/fs/binfmt_misc.c
> and it's obvious that 'interpreted interpreter' is intentional (and recursion depth is 4).
> So, execve is behave as it should and only man page is lag behind.
> Thank you for you help/
> 
> 
> Just curios - who use this feature in the real world and what for ?

It seems to have been changed in commit bf2a9a39639b8b51377905397a5005f444e9a892.
Maybe you could ask the author for details.


Johannes
