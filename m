Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab0FNMU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 08:20:59 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46597 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab0FNMU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 08:20:58 -0400
Date: Mon, 14 Jun 2010 13:20:51 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] docbook: need xmldoclinks for all doc types
Message-ID: <20100614122051.GW12061@shadowen.org>
References: <1276513297-23306-1-git-send-email-apw@canonical.com>
 <1276514142.14011.329.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276514142.14011.329.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 12:15:42PM +0100, Ben Hutchings wrote:
> On Mon, 2010-06-14 at 12:01 +0100, Andy Whitcroft wrote:
> > We need the xmldoclinks built for any document types built from the
> > XML sources.
> [...]
> 
> Yes, you're right, I don't know why I put xmldoclinks there.  It Worked
> For Me when building the linux-doc package in Debian.
> 
> However, the dependencies you're introducing seem to assume a serial
> make.  I think this (untested) change would get the dependencies right:

Bah, yeah and it just so happens that doc generation is occuring -j1.

> diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
> index 9d6f1a4..e9d75e6 100644
> --- a/Documentation/DocBook/Makefile
> +++ b/Documentation/DocBook/Makefile
> @@ -35,7 +35,7 @@ PS_METHOD	= $(prefer-db2x)
>  PHONY += xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs cleandocs xmldoclinks
>  
>  BOOKS := $(addprefix $(obj)/,$(DOCBOOKS))
> -xmldocs: $(BOOKS) xmldoclinks
> +xmldocs: $(BOOKS)
>  sgmldocs: xmldocs
>  
>  PS := $(patsubst %.xml, %.ps, $(BOOKS))
> @@ -95,7 +95,7 @@ define rule_docproc
>          ) > $(dir $@).$(notdir $@).cmd
>  endef
>  
> -%.xml: %.tmpl FORCE
> +%.xml: %.tmpl xmldoclinks FORCE
>  	$(call if_changed_rule,docproc)

Seems to work here in my testing.  Dependancy ordering wise it looks more
sensibl too.  Will you be sending this version out or do you want me to
roll it.

Acked-by: Andy Whitcroft <apw@canonical.com>

-apw
