Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab0J1CER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 22:04:17 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:36625 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757889Ab0J1CEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 22:04:14 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 27 Oct 2010 19:03:55 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx1
To: Andrew Morton <akpm@linux-foundation.org>
cc: Robin Holt <holt@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Patch] Convert max_user_watches to long.
In-Reply-To: <20101027164502.d6e2068d.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1010271751090.12650@davide-lnx1>
References: <20101027190914.146006767@gulag1.americas.sgi.com> <20101027190921.059806977@gulag1.americas.sgi.com> <20101027164502.d6e2068d.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010, Andrew Morton wrote:

> On Wed, 27 Oct 2010 14:09:15 -0500
> Robin Holt <holt@sgi.com> wrote:
> 
> > On a 16TB machine, max_user_watches has an integer overflow.  Convert it
> > to use a long and handle the associated fallout.
> > 
> 
> hand-wavy reality check:
> 
> Are the existing defaults sane?  How well does the code perform with a
> few billion watches?

Algorithmically, wake ups events are O(1) and add/mod/del are log2(N).
Tell you what though, if you give me a 16TB RAM box, I will tell you how 
it performs in reality ;)



> Is the expected use case one-watch-per-user-per-fd?  If so, then
> perhaps the max number of user_watches should have some realtionship
> with the max number of fds?

Yes, the expected case is one watch per fd, but the reason the watch limit 
went in in the first place, was because of DoS potential of someone not 
playing nicely.



- Davide


