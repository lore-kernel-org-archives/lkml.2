Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab2GRVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 17:25:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43445 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2GRVZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 17:25:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120718212044.GU31729@ZenIV.linux.org.uk>
References: <5006491D.8070004@t-online.de> <CA+55aFzv5mntf6y9e_r5=v+beG19xBv67EpA=dP0-Zw1CQrGGg@mail.gmail.com>
 <20120718212044.GU31729@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Jul 2012 14:25:02 -0700
X-Google-Sender-Auth: eGwqjnQrmLFIr53RVEUNR1v0Njg
Message-ID: <CA+55aFyHpgbJ9Pn5xn_ALkvzjQBOWog2qLbwwtrKbPHSGpa6pA@mail.gmail.com>
Subject: Re: [Bug 3.4.5] reiserfs: mutex_destroy called with locked mutex
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
        reiserfs-devel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 2:20 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Jul 18, 2012 at 09:26:57AM -0700, Linus Torvalds wrote:
>>
>> So I don't think the freeing code could trigger, but a concurrent
>> lookup then trying to look up the new directory (and taking the new
>> directory i_semaphore lock) could happen, afaik.
>
> Umm...  The thing is, we'd get WARN_ON() in iput_final() triggering in
> that scenario before lockdep could complain.

Not for the "look up directory in the dcache, and then lock that
inode" case, afaik. You'd get the lock before iput_final(), no?

So then "unlock_new_inode()" would run with the inode mutex held,
which could explain the lockdep warning, no?

             Linus
