Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab1E0Uhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:37:31 -0400
Received: from mail.perches.com ([173.55.12.10]:2162 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab1E0Uha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:37:30 -0400
Subject: Re: [patch v4] checkpatch: Signature format verification
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: anish singh <anish198519851985@gmail.com>,
        Manish Kumar Singh <man.k1983@gmail.com>, davej@redhat.com,
        apw@shadowen.org, akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1306527506.3857.41.camel@gandalf.stny.rr.com>
References: <1306006721.1622.18.camel@anish-desktop>
	 <1306059528.2761.3.camel@anish-desktop>
	 <1306164094.2292.25.camel@anish-desktop>
	 <1306519311.1918.12.camel@anish-desktop>
	 <1306520991.31864.9.camel@Joe-Laptop>
	 <BANLkTikfh_ABGomn-Lm9Ugc7MzeRodwiEQ@mail.gmail.com>
	 <1306523288.31864.29.camel@Joe-Laptop>
	 <BANLkTi=JK+XS2D0exj=unjpjGCsnVncCzQ@mail.gmail.com>
	 <1306524822.31864.50.camel@Joe-Laptop>
	 <BANLkTi=dsYi3ViZdpGdagxzhzDRuRVL_+A@mail.gmail.com>
	 <1306527506.3857.41.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 13:37:28 -0700
Message-ID: <1306528648.31864.62.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 16:18 -0400, Steven Rostedt wrote:
> On Sat, 2011-05-28 at 01:24 +0530, anish singh wrote:
> >         Anish, do you have a response to this?
> > Your approach is correct but i am trying to do in my own way.
> Why?? Correct is more important than individual preferences.

Thanks Steven, I was about to write something similar.

[]
> > In this if loop again i am catching name & rest of the things in $1.
> > $1 will be used for checking space between name & mail-id.
> BTW, people hate perl for this very reason. This subtle changing of $1
> is very hard to follow if you are not a perl expert. I use perl all the
> time (recordmcount.pl and ktest.pl), but if you look at my code, you
> will see that I purposely avoid these subtle characteristics of perl,
> because that's the (very rightfully so) reason people complain that perl
> is a write once and never maintain language.

I'm not a perl geek, nor do I want to be, but
that's exactly why I suggested after Anish's
first attempt something I think reasonably clear
and straightforward which avoids any reuse of $n.

Anish, please use this style.

	if ($line =~ /^(\s*)($ValidSignatures)(\s*)(.*)$/i) {
		my $space_before = $1;
		my $sign_off = $2;
		my $space_after = $3;
		my $email = $4;
		if (defined $space_before && $space_before ne "") {
			warning (no space before...)
		}
		if ($sign_off !~ /$Valid_Signature/) {
			warning (signature case...)
		}
		if (!defined $space_after || $space_after ne " ") {
			warning (need only one space after colon...)
		}
		if (!validate_email($email)) {
			warning (bad email...)
		}
	}

