Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab2FGRzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:55:21 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47070 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab2FGRzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:55:19 -0400
Date: Thu, 7 Jun 2012 13:48:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ben Guthro <ben@guthro.net>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen/hvc: Fix polling mode to work with
 kdb/kgdb
Message-ID: <20120607174815.GU9472@phenom.dumpdata.com>
References: <CAOvdn6VWdOy1nNM+x3ogCCFXy8FExZjTJaV-s6SR7kbGu+REOA@mail.gmail.com>
 <20120607164034.GQ9472@phenom.dumpdata.com>
 <CAOvdn6WJ+Ub+LbhHKKQJi3AzsbCqX6-ksWhoxnZS5_OH=hkghQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAOvdn6WJ+Ub+LbhHKKQJi3AzsbCqX6-ksWhoxnZS5_OH=hkghQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Thu, Jun 07, 2012 at 09:30:06AM -0400, Ben Guthro wrote:
> >> Fix the polling section of the hvc driver to use the global "last_hvc"
> >> variable, rather than the ttys.
> >
> > Could you just do:
> >
> >       struct tty_struct *tty = driver->ttys[last_hvc];
> >
> > as well?
> 
> No. I tried this, and never got to the kdb prompt.
> It seems that the problem is that you need to use the cons_ops variable
> 
> My efforts to fully understand the inner-workings of the console code
> were thwarted by time. Its a twisty bunch of code.
> If I used the cons_ops variable static to the module, it was OK.
> If I used driver->ttys - {get,put}_chars() never got called.

Well, now that you guys are working for a big corporation
you can relax and afford to spend some time digging in the
inner-workings I think :-)
.. snip..
> > Hm, if that is the problem then this should also be a problem on
> > IBM Power boxes I would think?
> 
> Not sure...but I think the original submitter of this code was
> 
> commit 762e77ae7dd055d0b77e0ad34d87db7416df109e
> Author: Anton Blanchard <anton@samba.org>
> Date:   Tue Jul 12 19:44:05 2011 +0000
> 
>     hvc_console: Add kdb support
> 
> 
> Was that for IBM?

No. But the 'hvc' system is used on IBM Power machines as well.
Hence my thought that if it didn't work under Xen it probably
didn't work under IBM Power machines either.

