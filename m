Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab2BIUkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:40:31 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:47217 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab2BIUka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:40:30 -0500
Date: Thu, 9 Feb 2012 16:40:18 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: Jan Beulich <JBeulich@suse.com>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen/tmem: cleanup
Message-ID: <20120209204018.GC14007@andromeda.dapyr.net>
References: <4F2C06A00200007800071071@nat28.tlf.novell.com> <d86f0be9-1530-47bd-b3fd-8c251e563b25@default> <4F2F998202000078000714CD@nat28.tlf.novell.com> <e871af1b-8003-4d3d-8fde-ea40545ff9fe@default> <4F3012B602000078000716AB@nat28.tlf.novell.com> <20120206170224.GD23240@phenom.dumpdata.com> <4F30E62B02000078000717EB@nat28.tlf.novell.com> <CACaajQt0MDNAN51g6AuYZn7ApwvuVgn+=GdyPNDJYVh95ecD0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACaajQt0MDNAN51g6AuYZn7ApwvuVgn+=GdyPNDJYVh95ecD0g@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 02:23:05PM +0400, Vasiliy Tolstov wrote:
> 2012/2/7 Jan Beulich <JBeulich@suse.com>:
> 
> >
> > As outlined above, it is possible, but I'm not certain it is a good idea
> > to have balloon_set_new_target() exported. If you think that's
> > acceptable, I can certainly put together a patch doing that (on top
> > of the one here, and probably not immediately).
> >
> > Jan
> 
> Exporting balloon_set_new_target can be grate feature to do own
> modules for balloon memory inside xen guest, becouse some times we
> need more realtime control from dom0 for memory growing speed inside
> guest.

Sounds like we have two use cases :-)

I am not seeing anything against it but I wonder if other virtualization
offerings would benefit from this as well? As in would it make sense to
export the virtio-ballon or the microsoft one as well? And perhaps have
an unified API? So that the ballloon drivers register and then have a
"virt_mem_set_new_target" exported?

