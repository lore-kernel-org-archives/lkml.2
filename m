Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab1GMD3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 23:29:00 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57573 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932349Ab1GMD27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 23:28:59 -0400
X-Sasl-enc: TAcWoznyBtadmA/41wXc+mKMgjngyTqJqJ0Lpx32AquM 1310527736
Date: Wed, 13 Jul 2011 05:28:12 +0200
From: Greg KH <greg@kroah.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg KH <gregkh@suse.de>, "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [09/35] ath9k: Fix suspend/resume when no
 interface is UP
Message-ID: <20110713032812.GA12262@kroah.com>
References: <20110708225343.GA14402@kroah.com>
 <20110708225119.722174548@clark.kroah.org>
 <CAP=VYLredMdZBA6uBbBqVL5p6FxCK2SqVGsJohG-nwiMtVxtVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP=VYLredMdZBA6uBbBqVL5p6FxCK2SqVGsJohG-nwiMtVxtVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Thanks for pointing this out, I've now dropped this patch.

greg k-h
