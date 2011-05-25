Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab1EYMcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:32:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52930 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab1EYMcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:32:18 -0400
Date: Wed, 25 May 2011 14:32:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v6] x86: UV uv_tlb.c cleanup
Message-ID: <20110525123207.GA22688@elte.hu>
References: <E1QOw12-0004MN-Lp@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QOw12-0004MN-Lp@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> General readability cleanup of tlb_uv.c. Now:

Ok, so this is clearly a big step forward so i've applied it and 
started testing it - hopefully we can work with small patches from 
now on.

I looked at uv_bau.h and tlb_uv.c and there's still sporadic 
problems:

 - Found at least one non-standard multi-line comment

 - Found at least one case where local variables were not followed by 
   an extra empty line

 - Sentences within comments are not capitalized consisently - some 
   start properly capitalized, some not.

 - In uv_bau.h there's no need to break the comment lines in such an 
   ugly way:

        unsigned long   s_ntarglocals;          /* targets of cpus on the local
                                                   blade */

   Just leave the comment in a single line! It's not a problem to 
   have lines longer than 80 cols - length up to 100 colums is fine 
   in such cases. The place where we frown upon too long lines is 
   *code*, because there the too long lines indicate various 
   structural problems.

 - There's still obscenely long field names such as
   socket_acknowledge_count. Why isnt that sock_ack_count? Note, 
   there's other such places, please try to find them an improve them
   where possible sanely. If you think there's no sane short name 
   available then obviously we want to live with the long name.

There might be other, easily noticeable problem in the file - please 
look yourself and try to improve it instead of forcing me to do this 
for you.

Thanks,

	Ingo
