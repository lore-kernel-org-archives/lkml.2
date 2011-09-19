Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab1ISGLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 02:11:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51773 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1ISGLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 02:11:03 -0400
Date: Mon, 19 Sep 2011 07:10:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ian Kent <raven@themaw.net>
Cc: Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dhowells@redhat.com
Subject: Re: [PATCH] Force same size of struct autofs_v5_packet on x86 and
 x86_64
Message-ID: <20110919061059.GJ2203@ZenIV.linux.org.uk>
References: <1316167604.6545.84.camel@localhost.localdomain>
 <20110916101903.GI2203@ZenIV.linux.org.uk>
 <1316169496.8502.6.camel@perseus.themaw.net>
 <1316332908.5814.22.camel@localhost.localdomain>
 <1316404368.3206.21.camel@perseus.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316404368.3206.21.camel@perseus.themaw.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 11:52:48AM +0800, Ian Kent wrote:

> > btw. where are the padding bytes are added? how to tell gcc to display
> > this?
> 
> It's also been a long time since I looked into this so I don't remember
> the processor alignment details.
> 
> Not sure if there is a compiler option that would report this, sorry,
> anyone else?

Padding is added in the very end.  The thing is, it's not a misaligned
field per se; they all have a natural alignment in there.  It's that
__u64 ino has alignment 8 on amd64 and alignment 4 on i386.  So the alignment
requirements for the entire structure are different - on amd64 the address
of the entire thing must be a multiple of 8 and on i386 it can be any multiple
of 4.  IOW, on i386 you can just put them one after another in e.g. an array
(the size without any padding is 300 bytes) and on amd64 you need 4 bytes
of padding added between them.  I.e. sizeof needs to go up by 4, with the
padding added in the end.
