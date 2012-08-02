Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2HBRso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:48:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53716 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab2HBRsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:48:43 -0400
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>, Tejun Heo <tj@kernel.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, paul.gortmaker@windriver.com
In-Reply-To: <CA+55aFw_dwO5ZOuaz9eDxgnTZFDGVZKSLUTm5Fn99faALxxJRQ@mail.gmail.com>
References: <20120731182330.GD21292@google.com> <50197348.9010101@gmail.com>
	 <20120801182112.GC15477@google.com> <50197460.8010906@gmail.com>
	 <20120801182749.GD15477@google.com> <50197E4A.7020408@gmail.com>
	 <20120801202432.GE15477@google.com> <5019B0B4.1090102@gmail.com>
	 <20120801224556.GF15477@google.com> <501A4FC1.8040907@gmail.com>
	 <20120802103244.GA23318@leaf> <501A633B.3010509@gmail.com>
	 <87txwl1dsq.fsf@xmission.com> <501AAC26.6030703@gmail.com>
	 <87fw851c3d.fsf@xmission.com>
	 <CA+55aFw_dwO5ZOuaz9eDxgnTZFDGVZKSLUTm5Fn99faALxxJRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Aug 2012 19:48:37 +0200
Message-ID: <1343929717.9299.358.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-02 at 10:32 -0700, Linus Torvalds wrote:
> On Thu, Aug 2, 2012 at 9:40 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >
> > For a trivial hash table I don't know if the abstraction is worth it.
> > For a hash table that starts off small and grows as big as you need it
> > the incent to use a hash table abstraction seems a lot stronger.
> 
> I'm not sure growing hash tables are worth it.
> 
> In the dcache layer, we have an allocated-at-boot-time sizing thing,
> and I have been playing around with a patch that makes the hash table
> statically sized (and pretty small). And it actually speeds things up!

By the way, anybody tried to tweak vmalloc() (or
alloc_large_system_hash()) to use HugePages for those large hash
tables ?



