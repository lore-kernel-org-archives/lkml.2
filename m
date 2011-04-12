Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab1DLVRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 17:17:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53421 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab1DLVRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:17:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NwUakX7Kzp6AbwAeTEYA095ZRIELhBwb1mzuqZjXNBy3gsssEq5L+B7f10g8HxgzgM
         WlZY84IENKTIophAVaZ/K0LbMXtobsghaXab45JBsJhZKwwKy6cOBal6L2tPtx++0i3/
         cTX5QnHAXCaehdEOIdlkopuJ9y7um7CnQPh3c=
Date: Wed, 13 Apr 2011 00:16:58 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        behlendorf1@llnl.gov, oleg@redhat.com
Subject: Re: [PATCH] remove abs64()
Message-ID: <20110412211658.GB20135@p183>
References: <20110412210045.GA19901@p183>
 <20110412140726.3f4f2a7b.rdunlap@xenotime.net>
 <20110412141040.a5706346.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412141040.a5706346.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 02:10:40PM -0700, Andrew Morton wrote:
> On Tue, 12 Apr 2011 14:07:26 -0700
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > > +	__builtin_choose_expr(						\
> > > +		__builtin_types_compatible_p(typeof(_x), long long),	\
> > > +		(unsigned long long)({ _x < 0 ? -_x : _x; }),		\
> > > +	_x)))));							\
> > > +})
> > 
> > that is better?
> 
> I think so.
> 
> It's a bit concerning that it changes the return type of abs().

I haven't read every abs() user, but, yes, sizeof(abs()) silently
changing is the issue.
