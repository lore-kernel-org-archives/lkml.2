Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab0JUPTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:19:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0JUPTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:19:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: Re: [RFC][PATCH 0/3] Coda: remove BKL
Date: Thu, 21 Oct 2010 17:20:28 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1287606184-26889-1-git-send-email-jaharkes@cs.cmu.edu> <201010211108.41320.arnd@arndb.de> <4CC058EC.1060200@cs.cmu.edu>
In-Reply-To: <4CC058EC.1060200@cs.cmu.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010211720.28775.arnd@arndb.de>
X-Provags-ID: V02:K0:cPL7nvNMGY/hq8yXG8VoGVFTXuDoTODfTOI/oedzBFM
 CO/Ez93Uc1N4oGxjLGE98SQf1XJeC+puFx5HkpMMmVReF+kElb
 5wVzE/Z2c1qD50h8kDL4BU/oPYD3usAiM8s3ZThEl9REIqwxI/
 L9gTyjN+aQwKI16zyYZ2c1xrOLsZn1wb4tbdhl9vezsP6+rduO
 bsZjiJKNM4qKPewLkXl5w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 October 2010, Jan Harkes wrote:
> On 10/21/2010 05:08 AM, Arnd Bergmann wrote:
> > On Wednesday 20 October 2010, Jan Harkes wrote:
> >> The following three patches remove the big kernel lock from the Coda
> >> file system kernel module. We initially add a spinlock to protect the
> >> Coda-specific inode data. After this we can push the BKL all the way
> >> down to where the requests are queued for the userspace Coda cache
> >> manager process and finally we replace the remaining BKL uses with a
> >> mutex that protects the upcall queues.
> > 
> > Very nice!
> > 
> > Are you pushing this to Linus or should I take care of it along with
> > the other file systems?
> > 
> > This patch is larger than most of the others, but I can add it to
> > my bkl/vfs tree if you like.
> 
> In that case it might be better when pushed separately, just to avoid
> any chances on a merge conflict for the bkl/vfs tree. I was thinking of
> letting the initial merges hit, rebase and retest over the weekend if
> there were any Coda related changes, and sending the final version to
> Linus by monday.
> 
> Besides, that gives me a couple of more days to make sure I weed out any
> remaining issues.

Ok, good.

I'll leave everything as is then, to avoid having to rebase myself.

This means you will get the conflict against the pushdown patch into
coda_fill_super, which is trivial to clean up by reverting part of
my patch and applying yours.

	Arnd
