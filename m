Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3AIA3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 19:29:39 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:43747 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab3AIA3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 19:29:37 -0500
Message-ID: <1357691375.1890.16.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ACPI: SRAT: report non-volatile memory in debug
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Jan 2013 16:29:35 -0800
In-Reply-To: <1692605.TGpS6mF86Q@vostro.rjw.lan>
References: <1357690556.1890.13.camel@buesod1.americas.hpqcorp.net>
	 <1692605.TGpS6mF86Q@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-09 at 01:34 +0100, Rafael J. Wysocki wrote:
> On Tuesday, January 08, 2013 04:15:56 PM Davidlohr Bueso wrote:
> > Just as with the other memory affinity flags, report
> > non-volatile memory with ACPI debug.
> 
> Looks kind of good, but ->
> 
> > Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> > ---
> >  drivers/acpi/numa.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
> > index cb31298..68077ac 100644
> > --- a/drivers/acpi/numa.c
> > +++ b/drivers/acpi/numa.c
> > @@ -116,12 +116,14 @@ acpi_table_print_srat_entry(struct acpi_subtable_header *header)
> >  			struct acpi_srat_mem_affinity *p =
> >  			    (struct acpi_srat_mem_affinity *)header;
> >  			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> > -					  "SRAT Memory (0x%lx length 0x%lx) in proximity domain %d %s%s\n",
> > +					  "SRAT Memory (0x%lx length 0x%lx) in proximity domain %d %s%s%s\n",
> >  					  (unsigned long)p->base_address,
> >  					  (unsigned long)p->length,
> >  					  p->proximity_domain,
> >  					  (p->flags & ACPI_SRAT_MEM_ENABLED)?
> >  					  "enabled" : "disabled",
> > +					  (p->flags & ACPI_SRAT_MEM_NON_VOLATILE)?
> > +					  " non-volatile" : "",
> 
> -> why did you put non-volatile before hot-pluggable?

No particular reason. Should I send a v2 with non-volatile at the end?

> 
> >  					  (p->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)?
> >  					  " hot-pluggable" : ""));
> >  		}
> 
> Rafael
> 
> 


