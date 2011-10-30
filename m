Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945Ab1J3KFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 06:05:08 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60588 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755516Ab1J3KFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 06:05:06 -0400
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20111026202235.GA20928@havoc.gtf.org>
References: <20111026202235.GA20928@havoc.gtf.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Oct 2011 14:05:01 +0400
Message-ID: <1319969101.5215.20.camel@dabdike>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-26 at 16:22 -0400, Jeff Garzik wrote:
> 2) The GPG wrapping causes all '^-' lines to become '^- -'.  This does NOT
>    reflect the true 'git diff' output, of course.
> 
>    For this reason, I am tempted to modify my new, GPG-signed pull request
>    template as follows, for subsequent pull requests:
> 
> 	---<begin GPG signed text>---
> 
>    	pull req description
> 
> 	"Please pull from $branch\n$url $branch"
> 
> 	"Top of tree is $sha1_commit"
> 
> 	---<end GPG signed text>---
> 
> 	diffstat
> 	diff
> 
>    That ensures that the critical part -- sha1 commit for top of tree --
>    is GPG signed, while the diff will be outside the signed area and therefore
>    not mangled by wrapping.

You can fix this by using mime and detached signatures as well but I
wouldn't worry too much about it.  What emerged at KS is that Linus uses
gmail and gmail has no integration with pgp, thus pgp signing of pull
requests is superfluous since Linus won't add the steps of saving the
message to a text file and manually running pgp over it to verify
because of the huge elongation in workflow this causes especially during
a merge window.

Ted Ts'o recommended using signed tags, but they're also a manual check.
I think the ultimate consensus will be that we'll have to wait until git
itself has pgp key handling built in (which the git people are looking
at) before we move to using the web of trust in pull requests.

James


