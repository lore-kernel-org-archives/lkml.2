Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab1HCTfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:35:13 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63381 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab1HCTfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:35:05 -0400
Date: Wed, 3 Aug 2011 23:34:57 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Richard Weinberger <richard@nod.at>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shm: optimize exit_shm()
Message-ID: <20110803193457.GA6734@albatros>
References: <20110803140456.GA14393@redhat.com>
 <20110803182417.GA2510@albatros>
 <20110803182826.GB2865@albatros>
 <20110803192138.GB31267@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803192138.GB31267@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 21:21 +0200, Oleg Nesterov wrote:
> > we should check .in_use once again after
> > down_write().
> 
> Why?

https://lkml.org/lkml/2011/8/3/277

"No, as I said in the comment above, other task may be holding the mutex and
deleting the last shm segment.  So, current task will see in_use == 1
before down_write(), but == 0 after it."

"Should" == additional check might speed the things, so it worth checking.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
