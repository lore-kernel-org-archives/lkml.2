Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab2EWGEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:04:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55765 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2EWGEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:04:36 -0400
Date: Wed, 23 May 2012 02:04:35 -0400
From: Kent Overstreet <koverstreet@google.com>
To: Joe Perches <joe@perches.com>
Cc: Tejun Heo <tejun@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
Subject: Re: [PATCH] Add human-readable units modifier to vsnprintf()
Message-ID: <20120523060435.GD14312@dhcp-172-18-216-138.mtv.corp.google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
 <20120522211706.GH14339@google.com>
 <20120523031214.GA607@dhcp-172-18-216-138.mtv.corp.google.com>
 <1337744190.13111.33.camel@joe2Laptop>
 <20120523045023.GE607@dhcp-172-18-216-138.mtv.corp.google.com>
 <1337749848.13111.40.camel@joe2Laptop>
 <20120523052236.GA14312@dhcp-172-18-216-138.mtv.corp.google.com>
 <1337751760.13111.47.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337751760.13111.47.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:42:40PM -0700, Joe Perches wrote:
> > Yeah, I already ran into that. I was looking through the gcc docs to see
> > if there was a way to add modifiers (how is it done for the other kernel
> > specific format strings?) but I haven't found anything yet
> 
> It's done via %p extensions.
> gcc doesn't care as long as the %p argument is a pointer.

Ahh

> 
> > > It's also possible
> > > to confuse it with printf's own 'h' / 
> > > integer precision use.
> > 
> > Well, that's annoying. Any suggestions?
> 
> I gave you one already.

Missed the reason for your suggestion :)

> 
> Use a new lib/vsprintf.c %p pointer extension like 
> "%pD" or "%pH" and use a pointer to the type as the
> argument.

Only trouble is we lose the existing method of specifying the type of
the integer. New flag character would make much more sense... if gcc
could be persuaded.
