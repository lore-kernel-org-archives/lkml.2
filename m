Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab2IYIyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:54:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48688 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab2IYIyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:54:43 -0400
Date: Tue, 25 Sep 2012 10:54:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: Zhi-zhou Zhang <etou.zh@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: git pull question
Message-ID: <20120925085439.GA1247@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Zhi-zhou Zhang <etou.zh@gmail.com>, linux-kernel@vger.kernel.org
References: <CACFOYQkXB0Ms-Bah5V6uQpeExbg7V5DOmuxE=XqOVrO76Lm9YA@mail.gmail.com>
 <CACFOYQm08W3fODbUYF51+Aw0x4izqs4-hT8jRDyX-tVnnnUS+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACFOYQm08W3fODbUYF51+Aw0x4izqs4-hT8jRDyX-tVnnnUS+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 04:22:42PM +0800, Zhi-zhou Zhang wrote:
> Hi all,
> 
> Today I update my kernel with git pull. Then a ploblem confused me. I
> got the below message with git status.
> I excuted git checkout master -f and git reset --hard master. The
> ploblem is still there. So anyone please help me
> to find what's the matter?
> 
>  # On branch master
> # Changes not staged for commit:
> #   (use "git add <file>..." to update what will be committed)
> #   (use "git checkout -- <file>..." to discard changes in working directory)
> #
> # modified:   include/linux/netfilter/xt_connmark.h
> # modified:   include/linux/netfilter/xt_dscp.h
> # modified:   include/linux/netfilter/xt_mark.h
> # modified:   include/linux/netfilter/xt_rateest.h
> # modified:   include/linux/netfilter/xt_tcpmss.h
> # modified:   include/linux/netfilter_ipv4/ipt_ecn.h
> # modified:   include/linux/netfilter_ipv4/ipt_ttl.h
> # modified:   include/linux/netfilter_ipv6/ip6t_hl.h
> # modified:   net/netfilter/xt_dscp.c
> # modified:   net/netfilter/xt_hl.c
> # modified:   net/netfilter/xt_rateest.c
> # modified:   net/netfilter/xt_tcpmss.c
> #
> no changes added to commit (use "git add" and/or "git commit -a")

do the following:

$ git checkout master	# in case you're not on it
$ git reset --hard
$ git clean -nd		# will show you which files it'll remove, check them
			# before actually removing them

$ git clean -fd		# remove them
$ git pull		# this now should fast-forward your master branch

HTH.

-- 
Regards/Gruss,
    Boris.
