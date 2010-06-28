Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab0F1LOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:14:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:40966 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0F1LOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:14:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=si6RD83bLD9beCKn2sAgPLxDphgncqaE5hd/QlSVvssW3Cwbeeo0DggEq5LC+NIi8l
         Re4++K+fvTr+ULoOZN0kMTrhOXZIfhaShT9WT/6z0DYtsOHYpy6rL8zugpTfA65CWJNn
         wt86qMu8GGzULyLOl8SGHhG4FqFP2speSmOwE=
Date: Mon, 28 Jun 2010 15:14:09 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: dkirjanov@kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Lior Dotan <liodot@gmail.com>,
       charrer@alacritech.com, "David S. Miller" <davem@davemloft.net>,
       Jiri Pirko <jpirko@redhat.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: slicoss: Change return codes to -EYYY.
Message-ID: <20100628111409.GA20103@shinshilla>
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
Yes, it seems that slic_link_event_handler & slic_config_get have to return error codes.

> > @@ -2267,7 +2267,7 @@ static u32 slic_card_locate(struct adapter *adapter)
> >
> >        ASSERT(card);
> >        if (!card)
> > -               return STATUS_FAILURE;
> > +               return -ENOMEM;
> 
> Is -ENOMEM correct for this case?
> 
Right, maybe ENXIO?

