Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab1DDSKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 14:10:16 -0400
Received: from mail.perches.com ([173.55.12.10]:4495 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab1DDSKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 14:10:15 -0400
Subject: Re: [PATCH V2 2/2] thinkpad_acpi: Convert printks to pr_<level>
From: Joe Perches <joe@perches.com>
To: sedat.dilek@gmail.com
Cc: Matthew Garrett <mjg@redhat.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTinKXtiNE=4xfNMh+nJBpiYUYFNRZQ@mail.gmail.com>
References: <664bf5e5585f3d959d6c57524d09353dd8d49f3f.1301936559.git.joe@perches.com>
	 <20110404130036.GB16669@srcf.ucam.org>
	 <c428cc13a1a5953be3310237e4f404ec65968d5a.1301936559.git.joe@perches.com>
	 <BANLkTinKXtiNE=4xfNMh+nJBpiYUYFNRZQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 11:10:13 -0700
Message-ID: <1301940613.1941.50.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 20:03 +0200, Sedat Dilek wrote:
> On Mon, Apr 4, 2011 at 7:06 PM, Joe Perches <joe@perches.com> wrote:
> > diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> [...]
> >  #ifdef CONFIG_THINKPAD_ACPI_DEBUG
> >  #define vdbg_printk dbg_printk
> >  static const char *str_supported(int is_supported);
> >  #else
> > -#define vdbg_printk(a_dbg_level, format, arg...) \
> > -       do { } while (0)
> > +static inline const char *str_supported(int is_supported) { return ""; }
> > +#define vdbg_printk(a_dbg_level, format, arg...)       \
> > +       no_printk(format, ##arg)
> >  #endif
> 
> Should be...
> +       do { } while (0)
> ...not...
> +       no_printk(format, ##arg)

I disagree.  No printk serves as a mechanism to verify
printk arguments when !CONFIG_THINKPAD_ACPI_DEBUG.


