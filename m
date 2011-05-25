Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab1EYOkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:40:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757866Ab1EYOkf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:40:35 -0400
MIME-Version: 1.0
In-Reply-To: <20110525084411.GB10146@htj.dyndns.org>
References: <1306262259-7285-1-git-send-email-tj@kernel.org>
 <1306262259-7285-8-git-send-email-tj@kernel.org> <BANLkTi=6KNJnaXO+guTke_kkinfBXNunBA@mail.gmail.com>
 <20110525084411.GB10146@htj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 May 2011 07:34:27 -0700
Message-ID: <BANLkTi=O5vG=pgaYsE-6GXODwF910Q2qwA@mail.gmail.com>
Subject: Re: [PATCH 07/19] ptrace: use bit_waitqueue for TRAPPING instead of wait_chldexit
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com, pedro@codesourcery.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 1:44 AM, Tejun Heo <tj@kernel.org> wrote:
>
> Sure, but can you at least explain why you dislike it so much?  This
> is the only place bit position is needed and having two variants with
> _BIT can be confusing (I did that more than once with workqueue code).
> ilog2() could be, I don't know, unfamiliar, but what's so crappy about
> it?

Have you looked at ilog2()?

Do you realize how much extra crap it is for the compiler? For
absolutely *no* reason.

I hate that disgusting thing. It basically screams to everybody "I'm a
f*cking moron, I did things the wrong way around, so now I use this
thing to undo my braindamage".

You can get a good idea of the code quality if you grep for users. I
don't think it's an accident at all that the two big blocks are
ide-tape and some infiniband drivers.

                         Linus
