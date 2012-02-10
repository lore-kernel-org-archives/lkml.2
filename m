Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab2BJTmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:42:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481Ab2BJTmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:42:40 -0500
Date: Fri, 10 Feb 2012 17:42:27 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        mingo@elte.hu, paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC 0/5] kernel: backtrace unwind support
Message-ID: <20120210194227.GG4998@infradead.org>
References: <1328873119-21553-1-git-send-email-jolsa@redhat.com> <1328895795.25989.29.camel@laptop> <CA+55aFxgPXjGh0GSHaUGm6-Pfdjjk=PAP7HMuZHcFGE92VutUQ@mail.gmail.com> <20120210192714.GE4998@infradead.org> <CA+55aFx9wxNkiW7QSLAmo+cAOOUjZef6a8xBfw88Wn+Nd9viNQ@mail.gmail.com> <20120210193932.GF4998@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210193932.GF4998@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 10, 2012 at 05:39:32PM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Fri, Feb 10, 2012 at 11:32:42AM -0800, Linus Torvalds escreveu:
> > On Fri, Feb 10, 2012 at 11:27 AM, Arnaldo Carvalho de Melo
> > > "Vote for --fno-omit-frame-pointer! One register is a cheap price to pay
> > > for not going insane!"

> > > /me goes back to non political things.

> > Even with -fomit-frame-pointer (which seems to be a big deal on Atom
> > in particular)
> 
> Nah, on such register starved arches we just do what we do today: try to
> figure out bogus addresses and bail out.

And the "interesting" thing is that at least on:

[acme@aninha linux]$ cat /etc/fedora-release 
Fedora release 14 (Laughlin)
[acme@aninha linux]$ uname -p
i686

I have -fno-omit-frame-pointer and get nice callchains, but if I try it
on fedora x86_64... b00m. Go figure.

- Arnaldo
