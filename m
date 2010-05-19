Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0ESP3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:29:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52787 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab0ESP3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:29:16 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: npiggin@suse.de, rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
       peterz@infradead.org, fweisbec@gmail.com, tardyp@gmail.com,
       mingo@elte.hu, acme@redhat.com, tzanussi@gmail.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem@davemloft.net, linux-mm@kvack.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       cl@linux-foundation.org, tj@kernel.org, jens.axboe@oracle.com
In-reply-to: <alpine.LFD.2.00.1005190736370.23538@i5.linux-foundation.org>
	(message from Linus Torvalds on Wed, 19 May 2010 07:39:11 -0700 (PDT))
Subject: Re: Unexpected splice "always copy" behavior observed
References: <20100518153440.GB7748@Krystal> <1274197993.26328.755.camel@gandalf.stny.rr.com> <1274199039.26328.758.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1005180918300.4195@i5.linux-foundation.org> <20100519063116.GR2516@laptop> <alpine.LFD.2.00.1005190736370.23538@i5.linux-foundation.org>
Message-Id: <E1OElCI-0005v6-4D@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 19 May 2010 17:28:38 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010, Linus Torvalds wrote:
> The real limitation is likely always going to be the fact that it has to 
> be page-aligned and a full page. For a lot of splice inputs, that simply 
> won't be the case, and you'll end up copying for alignment reasons anyway.

Another limitation I found while splicing from one file to another is
that stealing from the source file's page cache does not always
succeed.  This turned out to be because of a reference from the lru
cache for freshly read pages.  I'm not sure how this could be fixed.

Miklos
