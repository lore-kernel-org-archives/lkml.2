Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2LQRIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:08:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50909 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab2LQRIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:08:41 -0500
Date: Mon, 17 Dec 2012 18:08:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Arvind R <arvino55@gmail.com>, linux-edac@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH 3.7.0 3/9] i82975x_edac.c: cleanup debug code
Message-ID: <20121217170839.GA5194@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Arvind R <arvino55@gmail.com>, linux-edac@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
References: <CAA_L+UNa-C0XvzMbXMf9GchtfacfwJMYt2uuXkWVntWPWANLsA@mail.gmail.com>
 <20121217124511.66825216@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121217124511.66825216@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 12:45:11PM -0200, Mauro Carvalho Chehab wrote:
> Em Sun, 16 Dec 2012 02:10:39 +0530
> Arvind R <arvino55@gmail.com> escreveu:
> 
> > Subject: [PATCH 3.7.0 3/9] i82975x_edac.c: cleanup debug code
> > 
> > modify debug levels to sane levels. Also move random debug code
> > into CONFIG_EDAC_DEBUG sections.
> > Signed-off-by: Arvind R. <arvino55@gmail.com>
> > ---
> >  i82975x_edac.c |  171 +++++++++++++++++++++++-------------------
> >  1 file changed, 97 insertions(+), 74 deletions(-)
> > 
> > --- a/drivers/edac/i82975x_edac.c	2012-12-15 20:18:24 +0530
> > +++ b/drivers/edac/i82975x_edac.c	2012-12-15 20:17:58 +0530
> ...
> > @@ -551,11 +583,11 @@ static int i82975x_probe1(struct pci_dev
> >  	layers[1].is_virt_csrow = false;
> >  	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, sizeof(*pvt));
> >  	if (!mci) {
> > +		edac_dbg(0, "MC%d failed mc_alloc\n", dev_idx);
> >  		rc = -ENOMEM;
> >  		goto fail1;
> 
> Please remove the two last lines. There's no reason why it a driver 
> should bail out just because debug is enabled.

Huh? He's adding a debug line to say that edac_mc_alloc() failed.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
