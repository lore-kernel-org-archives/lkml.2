Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab0F3NCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:02:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51327 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab0F3NCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:02:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=SioD/AxCcY6efnne4LxUbSmVRb9WawEf2R1BXb4XGaz2GGorT5Tg1hmG8Pr0eCR1dR
         58+6yh9IMj7xAUACGOpMFUf9olhUExK1sMToP5LnoLoUQSNmGjJM2ehyyfNemooa+JiW
         RZrgOUXrnhHzA0fLy28YBltpcSdA0JALisLCo=
Date: Wed, 30 Jun 2010 17:02:40 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: dkirjanov@kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Lior Dotan <liodot@gmail.com>,
       charrer@alacritech.com, "David S. Miller" <davem@davemloft.net>,
       Jiri Pirko <jpirko@redhat.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: slicoss: Change return codes to -EYYY.
Message-ID: <20100630130240.GA3068@shinshilla>
References: <1277644847-16292-1-git-send-email-segooon@gmail.com>
 <AANLkTil3gkyn5vY9o0JYluRB4qUp1hdyfOHbX97OZfGJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTil3gkyn5vY9o0JYluRB4qUp1hdyfOHbX97OZfGJ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 14:12 +0400, Denis Kirjanov wrote:
> > diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
> > index bebf0fd..102d3ea 100644
> > --- a/drivers/staging/slicoss/slicoss.c
> > +++ b/drivers/staging/slicoss/slicoss.c
> > @@ -452,7 +452,7 @@ static int __devinit slic_entry_probe(struct pci_dev *pcidev,
> >
> >        status = slic_card_init(card, adapter);
> >
> > -       if (status != STATUS_SUCCESS) {
> > +       if (status != 0) {
> >                card->state = CARD_FAIL;
> >                adapter->state = ADAPT_FAIL;
> >                adapter->linkstate = LINK_DOWN;
> 
> Can we really continue here?
> 

It seems that we have to goto err_out_unmap, yes?

> > @@ -1206,7 +1206,7 @@ static void slic_link_event_handler(struct adapter *adapter)
> >  #else
> >        Stop compilation;
> >  #endif
> > -       ASSERT((status == STATUS_SUCCESS) || (status == STATUS_PENDING));
> > +       ASSERT(status == 0);
> >  }
> >
> 
> Now that looks useless since slic_upr_request can return STATUS_PENDING
> or -ENOMEM. Same for slic_config_get


Anyway, this code is full of ASSERT()'s, grep see 71 calls to it.
It needs more considered patch than these cleanup patches.
