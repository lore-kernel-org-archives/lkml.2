Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab2DWQZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:25:53 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:61206 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab2DWQZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:25:52 -0400
Date: Mon, 23 Apr 2012 09:25:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Zeev Tarantov <zeev.tarantov@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: commit 1cb41fe7e34a43a1d27dfdb6d65699786dd44c20 in stable
 (v3.3.3) breaks perf
Message-ID: <20120423162547.GA27669@kroah.com>
References: <20120423063704.GA3465@myhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120423063704.GA3465@myhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 09:37:04AM +0300, Zeev Tarantov wrote:
> gcc correctly complains:
> 
> util/hist.c: In function ‘__hists__add_entry’:
> util/hist.c:240:27: error: invalid type argument of ‘->’ (have ‘struct hist_entry’)
> util/hist.c:241:23: error: invalid type argument of ‘->’ (have ‘struct hist_entry’)
> 
> for this new code:
> 
> +                       if (he->ms.map != entry->ms.map) {
> +                               he->ms.map = entry->ms.map;
> +                               if (he->ms.map)
> +                                       he->ms.map->referenced = true;
> +                       }
> 
> because "entry" is a "struct hist_entry", not a pointer to a struct.
> 
> In mainline, "entry" is a pointer to struct passed as argument to the function.
> So this is broken during backporting. But obviously not compile tested. 
> Greg wrote on G+ that those who did not test 3.3.3-rc1 have no right to complain, but I'm complaining anyway. :P
> 
> See trivial patch to fix this.
> -Z.T.
> 
> P.S.
> I don't need credit for the patch so it's ok if my diff doesn't apply because of messed up whitespace.
> Just fix it.

Patch looks good to me, thanks for doing this, you are right in that I
didn't test perf.  I'll go queue this up right now.

greg k-h
