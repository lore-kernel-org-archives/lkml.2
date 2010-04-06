Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab0DFGTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 02:19:36 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:35350 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab0DFGTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 02:19:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BdFjxBhzqQnBC1hIEr8UtkH8CMLoYNJxqbBfeGFmKOj4RHXgf8EZd1bIuTn+H+wtG6
         Yh8NEqDrZYIKZov+6Se8tU7K4SjDf2uMAKwat34zkb8tLb9XnruvsD9yCNtZ0tM+5URa
         pBRPpxa+knSbmKQwK0OPVPoiKt2cnEPdY2DuY=
Subject: Re: Is module refcounting racy?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@gmail.com>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
In-Reply-To: <20100406050549.GA11191@laptop>
References: <20100318105533.GE25636@laptop>
	 <201003291942.56706.rusty@rustcorp.com.au>
	 <e619185d1003290958w23037176uc869c7dbc0a48bcc@mail.gmail.com>
	 <201003311414.49364.rusty@rustcorp.com.au> <20100401080940.GA8356@laptop>
	 <alpine.LFD.2.00.1004010852170.3707@i5.linux-foundation.org>
	 <20100406050549.GA11191@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 08:19:23 +0200
Message-ID: <1270534763.9013.55.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 06 avril 2010 à 15:05 +1000, Nick Piggin a écrit :

> Also if anyone else is looking at a way to do _really_ scalable
> refcounting elsewhere, this could be a good template (I certainly looked
> here first when trying to get ideas for vfsmount refcounting).

Yes, nice trick Nick, I was thinking about it for network code :)

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

I confess the smp_wmb() in module_put() bothered me a bit until I saw it
was only a barrier() on X86 (if !CONFIG_X86_OOSTORE)



