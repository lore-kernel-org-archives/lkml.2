Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab0ESPfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:35:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237Ab0ESPfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:35:41 -0400
Date: Wed, 19 May 2010 08:32:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: npiggin@suse.de, rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
       peterz@infradead.org, fweisbec@gmail.com, tardyp@gmail.com,
       mingo@elte.hu, acme@redhat.com, tzanussi@gmail.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem@davemloft.net, linux-mm@kvack.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       cl@linux-foundation.org, tj@kernel.org, jens.axboe@oracle.com
Subject: Re: Unexpected splice "always copy" behavior observed
In-Reply-To: <E1OElCI-0005v6-4D@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.2.00.1005190831460.23538@i5.linux-foundation.org>
References: <20100518153440.GB7748@Krystal> <1274197993.26328.755.camel@gandalf.stny.rr.com> <1274199039.26328.758.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1005180918300.4195@i5.linux-foundation.org> <20100519063116.GR2516@laptop>
 <alpine.LFD.2.00.1005190736370.23538@i5.linux-foundation.org> <E1OElCI-0005v6-4D@pomaz-ex.szeredi.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 May 2010, Miklos Szeredi wrote:
> 
> Another limitation I found while splicing from one file to another is
> that stealing from the source file's page cache does not always
> succeed.  This turned out to be because of a reference from the lru
> cache for freshly read pages.  I'm not sure how this could be fixed.

It should be fixed by saying "you can't always just move the page".

Copying is not evil. Complexity  to avoid copies is evil.

		Linus
