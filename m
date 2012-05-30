Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab2E3Se1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:34:27 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:43909 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753573Ab2E3SeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:34:25 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8W7rieUVM1mMvJHnJnzjy1TMFhCTKms6n.NoI8ZZQIFhSWQ
 bIu3dt8fxJESTcI4PvAg8bdlktsRwQBuT_HLwO35zQ2TIHTMadExLtOhWIAu
 7Q5xKnlLyL1qSsDeS0zbnw4oA7cFF7MspeC1ndtW1BpdQZemjn3dSIOnr5eX
 OtTJ.8iu3gsBSblWjYhm8dDSwqZwnFqQ2.EA8BCdqNdsixfJZFR9IfX5AtXu
 GOCGViFieZlJnNZOB5M2DtXtLALw.mBWJz84pV8iRWiH5bYneDHJTef4gTJZ
 QU0KfPjeqgbJUsMjP.6HBsbANft45xpGVYuxdyb8XgODDJsyKFS96WCqiH1l
 4QKaZfqz2Nav9isgzdza7w38E505lBtadBS.EMmNi3AH4u.LNjGvou_fFfCE
 R
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 30 May 2012 13:34:21 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@google.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        stable@vger.kernel.org, hughd@google.com, sivanich@sgi.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, andi@firstfloor.org
Subject: Re: [PATCH 0/6] mempolicy memory corruption fixlet
In-Reply-To: <CA+55aFzoVQ29C-AZYx=G62LErK+7HuTCpZhvovoyS0_KTGGZQg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205301328550.31768@router.home>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <CA+55aFzoVQ29C-AZYx=G62LErK+7HuTCpZhvovoyS0_KTGGZQg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012, Linus Torvalds wrote:

> On Wed, May 30, 2012 at 2:02 AM,  <kosaki.motohiro@gmail.com> wrote:
> >
> > So, I think we should reconsider about shared mempolicy completely.
>
> Quite frankly, I'd prefer that approach. The code is subtle and
> horribly bug-fraught, and I absolutely detest the way it looks too.
> Reading your patches was actually somewhat painful.

It is so bad mostly because the integration of shared memory policies with
cpusets is not really working. Using either in isolation is ok especially
shared mempolicies do not play well with cpusets.

> If we could just remove the support for it entirely, that would be
> *much* preferable to continue working with this code.

Well shm support needs memory policies to spread data across nodes etc.
AFAICT support was put in due to requirements to support large database
vendors (oracle). Andi?

Its not going to be easy to remove.

