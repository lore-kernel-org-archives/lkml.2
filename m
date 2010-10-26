Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737Ab0JZCcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:32:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40285 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab0JZCcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:32:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=thA4Ghc6JdVzDFQRndToTSVlT3LDQ/uVMu9i5Vo6WHH2yOGcI7+novq7/oXe3LrLls
         pcZaveBy5c3G325FjhK5pyrLGigf46RyAh9OskATN7o8YjTB1VnqVztHQS+KAW/WzJVc
         WCP8Hkxz8lQzi4TYxgS4B5lshKXOujjL0xF2g=
Subject: Re: [PATCH 0/29] My patch queue for memorystick subsystem
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Dubov <oakad@yahoo.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101025090721.c5d3fdc6.akpm@linux-foundation.org>
References: <1287972070.5205.12.camel@maxim-laptop>
	 <408703.12417.qm@web37603.mail.mud.yahoo.com>
	 <20101025090721.c5d3fdc6.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 04:32:13 +0200
Message-ID: <1288060333.4024.189.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 09:07 -0700, Andrew Morton wrote:
> On Mon, 25 Oct 2010 07:39:58 -0700 (PDT) Alex Dubov <oakad@yahoo.com> wrote:
> 
> > Normally, functional
> > patches should precede the cosmetic one, so that the functionality can be
> > discussed first.
> 
> More usually it's the other way around, actually: cleanups come first.
> 
> Because the cleanups are usually uncontroversial, and because
> substantive changes against cleaner code are easier to
> review/understand and because the substantive changes are then easier
> to revert or fix.

Exactly.

Now let me explain another technical reason why I did it that way.
First I created one big patch per driver I changed.
It really wasn't reviewable, but it was intended to review the end
result (the source file after patch was applied).
I did that because its really slows you down when you try to edit at
same time many patches. You have endless conflicts, you do lot of work
that you just remove in next patch etc.
Anyway this patchseries is a result of a lot of hard work (about month).



Alex pointer me that that isn't acceptable in linux community.
OK. I decided to bite the bullet and do that. It took me 2 full days to
split patches, test them (after all, I do honor the rule of
bisesctability).

Now why I put the cosmetic patches first?

Because that reduces conflicts during patch splitting dramaticly.

Consider this stack:


3: <top>
2: <few functions moved>
1: <few functions rewritten>
0: <existing source>

If I want to change patch #1, I will have to redo the patch #2 from the
start. That really sucks.


Now I could skip the functions that move code around, rename functions
etc to make Alex happy, but my goal was to minimize differences between
split-up series and original patch, so I could spare hard debugging.

This is result of lot of hard work.
I really want to see that in 2.6.37.


Best regards,
	Maxim Levitsky

