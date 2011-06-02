Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604Ab1FBMbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 08:31:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50829 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933477Ab1FBMbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 08:31:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gWapnf7AvlBZF+zAt6tzsduLskLLlmJN9sf6Uj34uUMI4vCHnKoWxPcQc4acngwzno
         0vEsTtHwqBWIzBOrcCcFouyIJdxfQoYAjhCyNccMI8M/c8pTmzgJbubDCI1NKuuZQjyZ
         dXP1gzb6ehFcgRd0Ha0WJSqwAoV13BRolqRjI=
Date: Thu, 2 Jun 2011 21:31:05 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
 group stop notification, take#4
Message-ID: <20110602123105.GD10410@mtj.dyndns.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
 <20110530154211.GA11325@redhat.com>
 <20110601053903.GE23067@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110601053903.GE23067@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Wed, Jun 01, 2011 at 02:39:03PM +0900, Tejun Heo wrote:
> I'll test different corner cases (different thread doing
> waking/sleeping, race against INTERRUPT kind of things) and let you
> know how it goes.

I've tested threaded one and INTERRUPT immediate re-triggering and at
least the apparent cases work fine.  I've re-generated the git tree on
top of 3.0-rc1 with the updated patches.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-ptrace-seize

The commit ID should be 7eae14288e745cfaabeb035fa67f89eb63a1aff7.  As
git.korg seems to be taking quite a while to sync, it might be a
better idea to pull from master.korg.

 ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-ptrace-seize

IIRC, pending issues are...

* Which signo to use in exit_code on STOP traps.

* Implicit signal on clone.

* What to do about events which are reported by genuine SIGTRAP
  generation?

* Group leader exit issue.

Thanks.

-- 
tejun
