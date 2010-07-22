Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab0GVHGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 03:06:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777Ab0GVHGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 03:06:14 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] dynamic debug: move ddebug_remove_module() down into free_module()
Date: Thu, 22 Jul 2010 09:07:48 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, hare@suse.de, yehuda@hq.newdream.net,
        stable@kernel.org
References: <20100714200056.GB2871@redhat.com> <20100721143423.5782c6ee.akpm@linux-foundation.org>
In-Reply-To: <20100721143423.5782c6ee.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007220907.49328.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 July 2010 23:34:23 Andrew Morton wrote:
> On Wed, 14 Jul 2010 16:00:57 -0400
> Jason Baron <jbaron@redhat.com> wrote:
> 
> > move the call to ddebug_remove_module() down into free_module(). In this way
> > it should be called from all error paths. Currently, we are missing the
> > remove if the module init routine fails.
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > Reported-by: Thomas Renninger <trenn@suse.de>
> > Tested-by: Thomas Renninger <trenn@suse.de>
> > CC: akpm@linux-foundation.org
> > CC: andi@firstfloor.org
> > CC: hare@suse.de
> > CC: trenn@suse.de
> > CC: yehuda@hq.newdream.net
> > CC: linux-kernel@vger.kernel.org
> 
> Crappy changelog doesn't describe the bug we're fixing.  It should.
> 
> It's
> 
> 	echo "file ec.c +p" >/sys/kernel/debug/dynamic_debug/control

> causes an oops, yes?
AFAIK the query written doesn't matter.
It's about the declaration of specific modules (see below).
If you compile out (a) specific module(s), above query might even
work.
 
... 
> Should we backport this into 2.6.34.x?  Earlier?
We saw oopses in 2.6.32 due to a module without an exit function
and overwriting the pr_fmt macro (not 100% sure whether both
conditions must be met, according to Hannes' test yes).
I expect the patch should go at least back to this one.
I can give it a try then whether this also fixes this condition.

      Thomas
