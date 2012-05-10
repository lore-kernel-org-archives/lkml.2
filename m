Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2EJUqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 16:46:14 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36258 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755526Ab2EJUqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 16:46:12 -0400
Message-ID: <1336682772.29763.6.camel@joe2Laptop>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Date: Thu, 10 May 2012 13:46:12 -0700
In-Reply-To: <CAPXgP11T7vjBBFaE5jne0hntZ2J-MoVxwJ2C9TNsRzme9DmLuQ@mail.gmail.com>
References: <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
	 <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
	 <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com>
	 <20120509070710.GA29981@gmail.com>
	 <CAPXgP11evyQQKNDaa00R7qsOFy5Xk-utN1w9OgB4y6NxLZG=UA@mail.gmail.com>
	 <1336611278.728.9.camel@mop>
	 <CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
	 <1336667984.947.24.camel@mop>
	 <CA+55aFxUaNC4SGEodrdddkDN6t=Sbx=P4XyaHkj7eTQBQOeLeA@mail.gmail.com>
	 <1336676986.947.47.camel@mop> <20120510201409.GA6467@thunk.org>
	 <1336682226.29763.2.camel@joe2Laptop>
	 <CAPXgP11T7vjBBFaE5jne0hntZ2J-MoVxwJ2C9TNsRzme9DmLuQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 22:39 +0200, Kay Sievers wrote:
> On Thu, May 10, 2012 at 10:37 PM, Joe Perches <joe@perches.com> wrote:
> > On Thu, 2012-05-10 at 16:14 -0400, Ted Ts'o wrote:
> >> Is there any difference in any of the cases in terms of how printk's
> >> that are prefixed with KERN_CONT versus a printk that does not have
> >> any KERN_* prefix?  If so, is there value in keeping KERN_CONT?
> >
> > As far as I know, no.
> >
> > It is a useful marker to show where prints
> > are actually continued.
> >
> > #define KERN_CONT ""
> >
> > would save a small amount of text.
> 
> Nah, we can't do that. We need it to tell "here is your non-prefix to
> parse, leave the data behind alone".

That's where I think you're still a bit
uncertain how the _current_ printk system
works.  Your _new_ printk system should
have identical behavior.  Though if you
manage to use the call tree and current to
coalesce complete messages more correctly,
that'd be great.


