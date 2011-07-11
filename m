Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab1GKHjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:39:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26031 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab1GKHjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:39:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6403"; a="102929899"
X-IronPort-AV: E=Sophos;i="4.65,511,1304319600"; 
   d="scan'208";a="45285918"
Date: Mon, 11 Jul 2011 10:51:18 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Greg KH <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
        <stable@kernel.org>, <stable-review@kernel.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [09/35] ath9k: Fix suspend/resume when no interface is UP
Message-ID: <20110711052117.GA797@vmraj-lnx.users.atheros.com>
References: <20110708225343.GA14402@kroah.com>
 <20110708225119.722174548@clark.kroah.org>
 <CAP=VYLredMdZBA6uBbBqVL5p6FxCK2SqVGsJohG-nwiMtVxtVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP=VYLredMdZBA6uBbBqVL5p6FxCK2SqVGsJohG-nwiMtVxtVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.12.4.3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 09, 2011 at 11:58:18AM -0400, Paul Gortmaker wrote:
> On Fri, Jul 8, 2011 at 6:49 PM, Greg KH <gregkh@suse.de> wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> >
> > ------------------
> >
> > From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> >
> > commit c31eb8e926835582cd186b33a7a864880a4c0c79 upstream.
> >
> > When no interface has been brought up, the chip's power
> > state continued as AWAKE. So during resume, the chip never
> > been powered up.
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >
> > ---
> >  drivers/net/wireless/ath/ath9k/pci.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > --- a/drivers/net/wireless/ath/ath9k/pci.c
> > +++ b/drivers/net/wireless/ath/ath9k/pci.c
> > @@ -276,6 +276,12 @@ static int ath_pci_resume(struct pci_dev
> 
> This might warrant a double check.   The original was patching the
> fullsleep into pci_suspend, not pci_resume, as is shown above here.
> 
Thanks Paul for pointing out.

> >                            AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
> >        ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
> >
> > +       /* The device has to be moved to FULLSLEEP forcibly.
> > +        * Otherwise the chip never moved to full sleep,
> > +        * when no interface is up.
> > +        */
> > +       ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
> > +
> >        return 0;
> >  }
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
