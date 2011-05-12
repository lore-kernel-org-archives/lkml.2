Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab1ELCNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 22:13:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685Ab1ELCNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 22:13:20 -0400
MIME-Version: 1.0
In-Reply-To: <4DCA4C05.4030803@redhat.com>
References: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz>
 <BANLkTikEpaRZK3X4YReeQAwgcv3HAGUwSw@mail.gmail.com> <alpine.DEB.2.00.1105091246550.32299@artax.karlin.mff.cuni.cz>
 <4DC7D37F.9040308@redhat.com> <20110509224511.GC15227@parisc-linux.org>
 <BANLkTikz-sGiy2NdzQMPzCWF64cVF-DZ7w@mail.gmail.com> <20110510225659.GE9253@agk-dp.fab.redhat.com>
 <4DCA4C05.4030803@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 May 2011 19:12:57 -0700
Message-ID: <BANLkTi=4raxPiRzBH=b44=SLsAujhx2xUw@mail.gmail.com>
Subject: Re: [PATCH] Don't mlock guardpage if the stack is growing up
To: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Matthew Wilcox <matthew@wil.cx>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 1:42 AM, Milan Broz <mbroz@redhat.com> wrote:
>
> Another one is cryptsetup [..]

Quite frankly, all security-related uses should always be happy about
a "MCL_SPARSE" model, since there is no point in ever bringing in
pages that haven't been used. The whole (and only) point of
mlock[all]() for them is the "avoid to push to disk" issue.

I do wonder if we really should ever do the page-in at all. We might
simply be better off always just saying "we'll lock pages you've
touched, that's it".

                       Linus
