Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab0G0ONi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 10:13:38 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49531 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab0G0ONh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 10:13:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ecWjv/6jThsDoTFUJQ5ad1k19uKR030L8bo1geBW691aTRZr1sbh2vwtkYMbKqI+vU
         XHK4UxKiGlsXdQn1ljlVXFYsFQakcRHT3D5fdjNdUZzIxSCdRgNp3iUWckB5/Y9kGPT+
         3gjtWrcwyMJ4HcdDj1cr8c0y2hXKratKAxo/s=
Date: Tue, 27 Jul 2010 18:13:31 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        Ryan Mallon <ryan@bluewatersys.com>,
        Yulia Vilensky <vilensky@compulab.co.il>
Subject: Re: [GIT PULL] battery-2.6.35.git
Message-ID: <20100727141331.GA5394@oksana.dev.rtsoft.ru>
References: <20100727135115.GA31789@oksana.dev.rtsoft.ru>
 <AANLkTim77oCDk9L8oYE5DCEKqZL_L_dm=mm-46=MZwX7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim77oCDk9L8oYE5DCEKqZL_L_dm=mm-46=MZwX7@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 04:03:14PM +0200, Geert Uytterhoeven wrote:
> On Tue, Jul 27, 2010 at 15:51, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> > diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
> > index d762a0c..9b3b4b7 100644
> > --- a/drivers/power/ds2782_battery.c
> > +++ b/drivers/power/ds2782_battery.c
> > @@ -43,10 +43,9 @@
> >  struct ds278x_info;
> >
> >  struct ds278x_battery_ops {
> > -       int     (*get_current)(struct ds278x_info *info, int *current_uA);
> > -       int     (*get_voltage)(struct ds278x_info *info, int *voltage_uA);
> > -       int     (*get_capacity)(struct ds278x_info *info, int *capacity_uA);
> > -
> > +       int (*get_battery_current)(struct ds278x_info *info, int *current_uA);
> > +       int (*get_battery_voltage)(struct ds278x_info *info, int *voltage_uA);
> > +       int (*get_battery_capacity)(struct ds278x_info *info, int *capacity_uA);
> 
> What's the meaning of these `uA' namings? At first I thought `micro Ampère', but
> that can't be correct for voltage (`uV'?) and capacity (`uAh'?).

Yeah, the names aren't quite right. But they were wrong before
that patch too, so a patch on top to fix these issues will work.

Cc'ing driver authors.

Thanks Geert!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
