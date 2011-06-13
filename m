Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1FMODc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:03:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53075 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab1FMODa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:03:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=a7Yf9oAfxfu4uJjrKjUQ5e2Vvk4aljxi0Y4zE4RGwuqHQ6dRHyUIK+wxi9ENGloaTm
         hU2k1PRAPZ7EY04CcAsQ==
Date: Mon, 13 Jun 2011 07:03:03 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Ying Han <yinghan@google.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [BUGFIX] update mm->owner even if no next owner.
In-Reply-To: <20110613105410.e06720f1.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.LSU.2.00.1106130655530.28913@sister.anvils>
References: <BANLkTikCfWhoLNK__ringzy7KjKY5ZEtNb3QTuX1jJ53wNNysA@mail.gmail.com> <BANLkTikF7=qfXAmrNzyMSmWm7Neh6yMAB8EbBp7oLcfQmrbDjA@mail.gmail.com> <20110610091355.2ce38798.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LSU.2.00.1106091812030.4904@sister.anvils>
 <20110610113311.409bb423.kamezawa.hiroyu@jp.fujitsu.com> <20110610121949.622e4629.kamezawa.hiroyu@jp.fujitsu.com> <20110610125551.385ea7ed.kamezawa.hiroyu@jp.fujitsu.com> <20110610133021.2eaaf0da.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LSU.2.00.1106101425400.28334@sister.anvils>
 <20110610235442.GA21413@cmpxchg.org> <20110611175136.GA31154@cmpxchg.org> <alpine.LSU.2.00.1106121828220.31463@sister.anvils> <20110613105410.e06720f1.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jun 2011, KAMEZAWA Hiroyuki wrote:
> On Sun, 12 Jun 2011 18:41:58 -0700 (PDT)
> Hugh Dickins <hughd@google.com> wrote:
> > 
> > The version I've signed off and am actually testing is below;
> > but I've not had enough time to spare on the machine which reproduced
> > it before, and another I thought I'd delegate it to last night,
> > failed to reproduce without the patch.  Try again tonight.
> > 
> > Thought I'd better respond despite inadequate testing, given the flaw
> > in the posted patch.  Hope the one below is flawless.
> > 
> 
> Thank you, I'll do test, too.

I confirm it fixes the bug: ran ten hours last night, when a couple
of tries just before without the patch each failed in ten minutes.

(But the load was not testing whether it keeps ownership when it should,
I hope you know a quick check on that: our earlier fixes should fail that.)

Hugh
