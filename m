Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab1GMXDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 19:03:34 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11865 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab1GMXDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 19:03:33 -0400
Date: Thu, 14 Jul 2011 01:03:31 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Peter Zijlstra <peterz@infradead.org>
cc: Jiri Kosina <jkosina@suse.cz>,
        =?ISO-8859-15?Q?Jan_H=2E_Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] sched: Fix (harmless) typo
 'CONFG_FAIR_GROUP_SCHED'
In-Reply-To: <1310597043.2586.60.camel@twins>
Message-ID: <alpine.LNX.2.00.1107140057240.22281@swampdragon.chaosbits.net>
References: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>  <1310580816-10861-2-git-send-email-schnhrr@cs.tu-berlin.de>  <1310590281.2586.34.camel@twins>  <alpine.LNX.2.00.1107140006170.5754@pobox.suse.cz>  <1310595172.2586.48.camel@twins> 
 <alpine.LNX.2.00.1107140029010.22281@swampdragon.chaosbits.net> <1310597043.2586.60.camel@twins>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011, Peter Zijlstra wrote:

> On Thu, 2011-07-14 at 00:35 +0200, Jesper Juhl wrote:
> > 
> > Don't know your workflow, but I can tell you what I do. I just have a 
> > branch for patches that I'm gathering that are not yet in upstream. Apply 
> > any new stuff there (or cherry-pick from other branches to my queue 
> > branch) and then regularly rebase that branch on master (Linus' tree).
> > When I then want to resend some patches it's as simple as checking out my 
> > queue branch, doing a rebase to make sure there's no obsolete stuff in it 
> > and then  git format-patch  to generate mails for the patches I want to 
> > re-send and then read those patches in to re-alpine and send them.
> > To me that's not very painfull, but of course it may not match your 
> > workflow - just a description of mine :-) . 
> 
> Right, so I find cherry-picking and rebasing using git the most painful
> thing ever.
> 
> Also, using quilt you get a plain text version of the patch you can edit
> at your leisure, editing a git patch involves some export, import and
> rebase foo which is all too much work.
> 

Hmm, if I want to modify a patch in my queue I'll do something like this:

$ git checkout queue

$ git rebase --interactive HEAD~5  (or however long I need to go back)

## change the 'pick' for the patch I want to change to 'edit' in the list 
## that pops up in my editor.

## edit the files I need to edit

$ git add <modified files>

$ git commit --amend

## update patch description (if needed)

$ git rebase --continue

<done>

perhaps that seems too much work to you - for me it works just fine..


> Furthermore, using quilt I get help from useful tools like rej and meld
> git-merge otoh creates these god-awful merge markers that no tool can
> deal with.
> 
don't use those tools, so can't really comment.

> As for re-alpine, I might actually try it, you're the second one
> promoting it. Although I had somewhat hoped for a MUA like sup to become
> useful (or notmuch to grow a usable front-end). Traditional MUAs simply
> can't seem to cope well with today's number of emails.

Do yourself a favour, if you try it, and spend a bit of time in the Setup 
menu configuring it to the threading style you want, the headers you want 
displayed by default, etc etc... The defaults are less than perfect if you 
ask me, but it's quite configurable :)

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

