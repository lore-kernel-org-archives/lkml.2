Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab1DMU1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:27:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758515Ab1DMU1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:27:09 -0400
Date: Wed, 13 Apr 2011 13:26:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        behlendorf1@llnl.gov
Subject: Re: [PATCH] remove abs64()
Message-Id: <20110413132629.6111f7f2.akpm@linux-foundation.org>
In-Reply-To: <20110413202031.GA19113@redhat.com>
References: <20110412210045.GA19901@p183>
	<20110413142703.GA1511@redhat.com>
	<20110413114808.12783565.akpm@linux-foundation.org>
	<20110413202031.GA19113@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 22:20:31 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> > > But, we have some stupid users which do something like abs(u32_value)
> > > and expecting that abs() should treat this value as "signed".
> > >
> >
> > um, yes, I'd forgotten that one.  That's a show-stopper.
> 
> May be we can demand to fix them?
> 
> I agree with Alexey, it is a bit ugly to have abs() and abs64(), and abs()
> itself doesn't look very nice.
> 
> What if we simply add
> 
> 	BUILD_BUG_ON( (typeof(_x)-1) > 0 );
> 
> into abs()?
> 
> After that it would be trivial to find the offenders and fix them,
> 
> 	- abs(unsigned_int)
> 	+ abs((int) unsigned_int)

Something like that.  But it should be done before we change abs(), to
avoid nasty breakage in obscure places.

Or we rework the abs() implementation so that the abs(unsigned)
behavior is unchanged.

There will remain the problem that the abs() return value's signedness
has changed.
