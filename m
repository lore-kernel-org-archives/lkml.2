Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab1EYOmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:42:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37621 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457Ab1EYOmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:42:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=jrymZQC316PS+Wjdr/Fov5gvfP/Fin5jaF2dsFJQnPKofAfII/B9HvU1XxwvPe9Ki9
         3ZEi2ShvYOdELcp5wRktj7VCo1kBg9PBHMPpjX96f38Q/9IzfUs0r58x1aXMsUE51bsv
         Cl3GkZtmKzl2BDpFu9OSmGWIBAPjqfW9wCLnM=
Date: Wed, 25 May 2011 16:42:14 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: oleg@redhat.com, vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com, pedro@codesourcery.com
Subject: Re: [PATCH 07/19] ptrace: use bit_waitqueue for TRAPPING instead
 of wait_chldexit
Message-ID: <20110525144214.GK10146@htj.dyndns.org>
References: <1306262259-7285-1-git-send-email-tj@kernel.org>
 <1306262259-7285-8-git-send-email-tj@kernel.org>
 <BANLkTi=6KNJnaXO+guTke_kkinfBXNunBA@mail.gmail.com>
 <20110525084411.GB10146@htj.dyndns.org>
 <BANLkTi=O5vG=pgaYsE-6GXODwF910Q2qwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=O5vG=pgaYsE-6GXODwF910Q2qwA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 07:34:27AM -0700, Linus Torvalds wrote:
> On Wed, May 25, 2011 at 1:44 AM, Tejun Heo <tj@kernel.org> wrote:
> > Sure, but can you at least explain why you dislike it so much?  This
> > is the only place bit position is needed and having two variants with
> > _BIT can be confusing (I did that more than once with workqueue code).
> > ilog2() could be, I don't know, unfamiliar, but what's so crappy about
> > it?
> 
> Have you looked at ilog2()?

Yeap, I did.

> Do you realize how much extra crap it is for the compiler? For
> absolutely *no* reason.
>
> I hate that disgusting thing. It basically screams to everybody "I'm a
> f*cking moron, I did things the wrong way around, so now I use this
> thing to undo my braindamage".

I don't know.  The overhead is compile-time and if the bit position
usage is very rare compared to bitmask usage, it is convenient.

> You can get a good idea of the code quality if you grep for users. I
> don't think it's an accident at all that the two big blocks are
> ide-tape and some infiniband drivers.

Maybe, but also ilog2() is relatively new and most already had ways to
deal with bit positions and masks, so the uptake is expected to be
slow.

Anyways, understood.  Linus hates ilog2().  Will convert to _BIT
macros on the next round and stay the f$@? away from it from now on.

Thanks.

-- 
tejun
