Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab2I0I3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:29:16 -0400
Received: from mx0.aculab.com ([213.249.233.131]:35970 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750990Ab2I0I3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:29:09 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v6] hashtable: introduce a small and naive hashtable
Date: Thu, 27 Sep 2012 09:25:25 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7009@saturn3.aculab.com>
In-Reply-To: <20120926161956.GB28648@Krystal>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v6] hashtable: introduce a small and naive hashtable
thread-index: Ac2cAs0ZmYnQGw2KRryfA0lJsPhaqAAhdFRw
References: <1348663729-2584-1-git-send-email-levinsasha928@gmail.com> <AE90C24D6B3A694183C094C60CF0A2F6026B7008@saturn3.aculab.com> <1348667992.22822.50.camel@gandalf.local.home> <506310AA.2050700@gmail.com> <20120926143905.GB22699@Krystal> <1348675764.22822.56.camel@gandalf.local.home> <20120926161956.GB28648@Krystal>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
        "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Sasha Levin" <levinsasha928@gmail.com>, <torvalds@linux-foundation.org>,
        <tj@kernel.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <ebiederm@xmission.com>,
        <neilb@suse.de>, <bfields@fieldses.org>, <ejt@redhat.com>,
        <snitzer@redhat.com>, <edumazet@google.com>, <josh@joshtriplett.org>,
        <rmallon@gmail.com>, <palves@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > And even then, if we would do:
> > >
> > >  	for (i = 0; i < HASH_SIZE(hashtable); i++)
> > >  		if (!hlist_empty(&hashtable[i]))
> > >  			break;
> > >
> > >  	return i >= HASH_SIZE(hashtable);
> > >
> > > What happens if the last entry of the table is non-empty ?
> >
> > It still works, as 'i' is not incremented due to the break. And i will
> > still be less than HASH_SIZE(hashtable). Did you have *your* cup of
> > coffee today? ;-)
> 
> Ahh, right! Actually I had it already ;-)

I tend to dislike the repeated test, gcc might be able to optimise
it away, but the code is cleaner written as:

	for (i = 0; i < HASH_SIZE(hashtable); i++)
		if (!hlist_empty(&hashtable[i]))
			return false;
	return true;

> Agreed that the flags should be removed. Moving to define + static
> inline is still important though.

Not sure I'd bother making the function inline.

	David



