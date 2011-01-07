Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1AGPnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:43:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:54897 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab1AGPnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:43:06 -0500
Date: Fri, 7 Jan 2011 16:43:02 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: GIT again
Message-ID: <20110107154302.GF1891@tiehlicka.suse.cz>
References: <4D272D7C.4070900@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D272D7C.4070900@example.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 07-01-11 16:13:00, Piotr Hosowicz wrote:
> Hello,
> 
> Sorry for bothering again. I think I fimanaged to build the kernel
> as I wanted to. Lets simplify the problem. There is Linus tree and a
> separate tree, which was announed here as:
> 
> git://git.kernel.org/some.git for-linus
> 
> The objective is to build the kernel with Linus sources with
> some.git changes incorporatwed in it. I think I managed to achieve
> the objective doing:
> 
> # let me remind myself ;-)
> git clone <Linus URL here>
> git remote add some git://git.kernel.org/some.git
> git pull some for-linus

Yes, this will merge some/for-linus branch into the current branch which
is master (from the above sequence of commands).
 
> I've done it this way and I am convinced I've achieved the
> objective. But not sure. 

git pull is essentially the same thing as git fetch and git merge. The
first command fetches all commits from the remote and the second one
will merge your current tree with the given branch (it doesn't care much
about the fact those commits come from a remote repository as those
objects are available locally after fetch)

> For sure the last command modified the
> source, what is what I wanted, I had to finally correct ot by hand
> and do git commit -a.

This is because you could end up with some conflicts after merge.
Anyway, git commit -a is not the best way to do this in general. I would
encourage you to use git status to get an overview of what has changed
(what is the conflict etc...) and selectively git add only those changes
that are relevant and then git commit after you are done.

Btw. the way you did this is not very much optimal. You have merged
something into your _master_ branch which means that when-ever you want
to pull again from linus you will have to merge again. In general I tend
to keep the _master_ branch without any modifications and do all my
changes (merges with other external sources etc.) in dedicated branches
so that I can keep following linus master without any modifications.

> 
> Am I right?
> 
> Regards,
> 
> Piotr Hosowicz
> 
> -- 
> - Poszed?em wczoraj z ?on? do ZOO
> - I jak?
> - Nie wzi?li...
> NP: Peter Green Splinter Group - Turn Your Love Away
> NB: 2.6.37-20110107-1437-pztidm+
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
