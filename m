Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab0DSSLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 14:11:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab0DSSLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 14:11:19 -0400
Date: Mon, 19 Apr 2010 20:11:10 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: lkml <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: trace-cmd: make Makefile rpm-friendly
In-Reply-To: <20100419100058.6f1457dd.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.2.00.1004191942010.4111@localhost.localdomain>
References: <20100419100058.6f1457dd.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Apr 2010, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Update Makefile to support rpmbuild DESTDIR usage.

So, what would happen if you did
make DESTDIR=/usr/local install ?

I think you would get /usr/local/usr/local
So, I think I would NAK this patch.

I also don't believe there is anything magical about DESTDIR in a spec 
file. Essentially, prefix in this makefile is equivalent to DESTDIR, so 
you can replace DESTDIR with prefix in a spec template.
 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Makefile |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> --- trace-cmd-0.7.0.orig/Makefile
> +++ trace-cmd-0.7.0/Makefile
> @@ -18,10 +18,11 @@ AR = $(CROSS_COMPILE)ar
>  EXT = -std=gnu99
>  INSTALL = install
>  
> +DESTDIR =
>  prefix ?= /usr/local
>  bindir_relative = bin
> -bindir = $(prefix)/$(bindir_relative)
> -man_dir = $(prefix)/share/man
> +bindir = $(DESTDIR)/$(prefix)/$(bindir_relative)
> +man_dir = $(DESTDIR)/$(prefix)/share/man
>  man_dir_SQ = '$(subst ','\'',$(man_dir))'
>  
>  export man_dir man_dir_SQ INSTALL
> @@ -29,7 +30,7 @@ export man_dir man_dir_SQ INSTALL
>  ifeq ($(prefix),$(HOME))
>  plugin_dir = $(HOME)/.trace-cmd/plugins
>  else
> -plugin_dir = $(prefix)/share/trace-cmd/plugins
> +plugin_dir = $(DESTDIR)/$(prefix)/share/trace-cmd/plugins
>  PLUGIN_DIR = -DPLUGIN_DIR=$(plugin_dir)
>  PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
>  endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
