Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab1HMGeN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 02:34:13 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:47427 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab1HMGeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 02:34:11 -0400
Date: Sat, 13 Aug 2011 08:34:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] ARM: zImage: Skip relinking if nothing changes
Message-ID: <20110813063409.GA29111@merkur.ravnborg.org>
References: <4E457682.5020107@codeaurora.org> <1313175602-21834-1-git-send-email-sboyd@codeaurora.org> <CACqU3MUq5M-XPOxV=8GKyEzjEzpmdeaF+mGrXJrK+ZZxa4SdeQ@mail.gmail.com> <20110812205520.GL4775@n2100.arm.linux.org.uk> <CACqU3MX=-10ouxCqWcBP7MW3_O4_RSLG9wRY8X4iEh5ydQa1AQ@mail.gmail.com> <20110812220316.GA28845@merkur.ravnborg.org> <CACqU3MUVir_hfAtVz24Y7NrQOHAa=WyyHnCN4M6BHLQ294Tdww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACqU3MUVir_hfAtVz24Y7NrQOHAa=WyyHnCN4M6BHLQ294Tdww@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 06:17:25PM -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Fri, Aug 12, 2011 at 6:03 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> >>
> >> I suspect this would have done the job:
> >>
> >> $(obj)/font.o: $(srctree)/drivers/video/console/font_acorn_8x8.c
> >>         $(cmd,cc_o_c)'
> >
> > I prefer using $(call,shipped) and let kbuild figure out how
> > build an .o file from a .c file.
> >
> > In other words - avoiding use of the internal to Makefile.build
> > variables in various places.
> >
> indeed, but I'd argue that 1) this would not be the first Makefile
> using these internal macros (alpha and ia64 are using such construct
> for aliasing) and 2) the `cmd_shipped' stuff is as internal than other
> functions :-)
A quick grep in Documentation/kbuild will show that only the shipped
variant is documented.

We could implement a general copy command - this is needed in some places
like this.

	Sam
