Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab2AaPZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:25:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57107 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2AaPZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:25:41 -0500
Date: Tue, 31 Jan 2012 16:25:34 +0100
From: Karsten Keil <kkeil@linux-pingi.de>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Danny Kukawka <danny.kukawka@bisect.de>, Armin Schindler <mac@melware.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Karsten Keil <isdn@linux-pingi.de>
Subject: Re: [PATCH 01/16] eicon: fix -Warray-bounds warning
Message-ID: <20120131152534.GA14825@gw.linux-pingi.de>
Mail-Followup-To: Ben Hutchings <bhutchings@solarflare.com>,
	Danny Kukawka <danny.kukawka@bisect.de>,
	Armin Schindler <mac@melware.de>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
 <1327960820-11867-2-git-send-email-danny.kukawka@bisect.de>
 <1327964972.2595.31.camel@bwh-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327964972.2595.31.camel@bwh-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:4C8JEwuTDgqdwDw7YqxOP9kKFQBK8Q52qX8HkBMO2Ia
 NrIpf7THSVdd3Zf3nUcPy4d6heGELAMo++1mZAb1qXYJMgq7Ig
 lksjKjuhTeTjxJO7NnfqTnFIKljuiMf5M+Nl9clvwou+vjM1pj
 xfxi4szHtV+znO2cuPssYYmAEvqYwa79U7YanOV2lVcxwsURNB
 fEj6qDl4CipC5IqWRIyIvdIEljzZd2F4wI1rUkS6ttezjmBu3T
 kRMeMHkxDZW/56zYjHOTbW1040E7cwcekOubf16dP3dn6h+/8j
 3g+ZoBse26YKmCmoHFU/untFFmQ0Mq8ILvytugura7XkblL7r8
 KW8G5Xc93mhNzXYDnsewWPKa9xKMEv35Nxbmse28e65WOwVE4S
 swd3TPT4nct2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 11:09:32PM +0000, Ben Hutchings wrote:
> On Mon, 2012-01-30 at 23:00 +0100, Danny Kukawka wrote:
> > Fix for a -Warray-bounds warning. mixer_notify_update() tries to
> > write to ((CAPI_MSG *) msg)->info.facility_req.structs[3] while
> > structs is defined as byte structs[1], define structs[1] as
> > structs[4].
> 
> I suspect that all the 'byte structs[1];' fields defined in that header
> are actually variable-length arrays.  In that case, there may be no
> reasonable bound you can specify.

Yes, exactely, the structs is a ASN1 coded message so it can have any len.

Karsten

> 
> Ben.
> 
> > Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> > ---
> >  drivers/isdn/hardware/eicon/capi20.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/isdn/hardware/eicon/capi20.h b/drivers/isdn/hardware/eicon/capi20.h
> > index 7ebcccd..f9170ad 100644
> > --- a/drivers/isdn/hardware/eicon/capi20.h
> > +++ b/drivers/isdn/hardware/eicon/capi20.h
> > @@ -226,7 +226,7 @@ typedef struct {
> >          /* FACILITY-REQUEST */
> >  typedef struct {
> >    word Selector;
> > -  byte structs[1];      /* Facility parameters */
> > +  byte structs[4];      /* Facility parameters */
> >  } _FAC_REQP;
> >          /* FACILITY-CONFIRM STRUCT FOR SUPPLEMENT. SERVICES */
> >  typedef struct {
> 
