Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab1DLVkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 17:40:36 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:58400 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932568Ab1DLVkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:40:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=AeXp6lv8NpLhr+ocptYUoZa05YRyXnlAqQhvrHsZl/kq9JIr62rI/QFsY1oP8ufbz+9ES3B0Nqb6+yBNgIkEDk24KLjcJWOuxjrN9MbSr3ieF7dpwo3n0IXsPFXvMZfC;
Date: Tue, 12 Apr 2011 14:40:32 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        behlendorf1@llnl.gov, oleg@redhat.com
Subject: Re: [PATCH] remove abs64()
Message-Id: <20110412144032.1fc09497.rdunlap@xenotime.net>
In-Reply-To: <20110412143340.e26fc370.akpm@linux-foundation.org>
References: <20110412210045.GA19901@p183>
	<20110412140726.3f4f2a7b.rdunlap@xenotime.net>
	<20110412141040.a5706346.akpm@linux-foundation.org>
	<20110412211658.GB20135@p183>
	<20110412143340.e26fc370.akpm@linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011 14:33:40 -0700 Andrew Morton wrote:

> On Wed, 13 Apr 2011 00:16:58 +0300
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > On Tue, Apr 12, 2011 at 02:10:40PM -0700, Andrew Morton wrote:
> > > On Tue, 12 Apr 2011 14:07:26 -0700
> > > Randy Dunlap <rdunlap@xenotime.net> wrote:
> > > 
> > > > > +	__builtin_choose_expr(						\
> > > > > +		__builtin_types_compatible_p(typeof(_x), long long),	\
> > > > > +		(unsigned long long)({ _x < 0 ? -_x : _x; }),		\
> > > > > +	_x)))));							\
> > > > > +})
> > > > 
> > > > that is better?
> > > 
> > > I think so.
> > > 
> > > It's a bit concerning that it changes the return type of abs().
> > 
> > I haven't read every abs() user, but, yes, sizeof(abs()) silently
> > changing is the issue.
> 
> It changes signedness_of(abs(signed_expr)) as well.  That changes the
> signedness of expressions which use abs() and on and on.
> --

thanks for the further explanations.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
