Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab1EYIoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:44:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59419 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab1EYIoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:44:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qpkLGriVxceJSWf1jpurHPBwD6HzmteQVuIzXoo95Fxh2rJBO+GkfomDzvlL+vQXcE
         AW6dhYqxZtBOgrTcqQmcTndrbGnIoVBuUX8gCf6t2tHfpinrn84wtbxrFJ+sXAQOoXnf
         RkHt7qok0BYoP7Sci+wKsqRPDTxtbEXtSiMck=
Date: Wed, 25 May 2011 10:44:11 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: oleg@redhat.com, vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com, pedro@codesourcery.com
Subject: Re: [PATCH 07/19] ptrace: use bit_waitqueue for TRAPPING instead
 of wait_chldexit
Message-ID: <20110525084411.GB10146@htj.dyndns.org>
References: <1306262259-7285-1-git-send-email-tj@kernel.org>
 <1306262259-7285-8-git-send-email-tj@kernel.org>
 <BANLkTi=6KNJnaXO+guTke_kkinfBXNunBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=6KNJnaXO+guTke_kkinfBXNunBA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Tue, May 24, 2011 at 12:03:16PM -0700, Linus Torvalds wrote:
>   #define JOBCTL_TRAPPING_BIT xxx
>   #define JOBCTL_TRAPPING (1u << JOBCTL_TRAPPING_BIT)
> 
> but never ever do that stupid ilog2() thing. Every time I see it I go
> "ok, that's just total crap".
> 
> Don't do it.

Sure, but can you at least explain why you dislike it so much?  This
is the only place bit position is needed and having two variants with
_BIT can be confusing (I did that more than once with workqueue code).
ilog2() could be, I don't know, unfamiliar, but what's so crappy about
it?

Thanks.

-- 
tejun
