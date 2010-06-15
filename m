Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab0FOPg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 11:36:26 -0400
Received: from xenotime.net ([72.52.115.56]:42347 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932346Ab0FOPgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 11:36:24 -0400
Date: Tue, 15 Jun 2010 08:36:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Andy Whitcroft <apw@canonical.com>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docbook: need xmldoclinks for all doc types
Message-Id: <20100615083623.2dbaab24.rdunlap@xenotime.net>
In-Reply-To: <1276563314.14011.361.camel@localhost>
References: <1276513297-23306-1-git-send-email-apw@canonical.com>
	<1276514142.14011.329.camel@localhost>
	<1276563314.14011.361.camel@localhost>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 01:55:14 +0100 Ben Hutchings wrote:

> Andy Whitcroft wrote:
> > We need the xmldoclinks built for any document types built from the
> > XML sources.
> 
> Indeed we do.  So make the XML files depend on xmldoclinks.

The patch description tells me what but not why.

IOW, what error is this fixing and how do I produce that error
when this patch is not applied?

Thanks.

> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Acked-by: Andy Whitcroft <apw@canonical.com>
> ---
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
>  
>  ###
> 
> -- 
> Ben Hutchings
> Once a job is fouled up, anything done to improve it makes it worse.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
