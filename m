Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab0KXKyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:54:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54636 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab0KXKyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:54:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WuTQQaOLnZcZOyc/vMp+NsBrWan9omPJ3DaDdlqSvX0h7RbirFlcaaiQedJJDgABrh
         pMSwzXW1LoSNMoD1Jj1ElRuAA+nL2piDxN5M/HfKBxxpRDWHtkk0RmnlhdKO79qrbs+K
         bgrJosLS64ws1o8pa4Az8ohRKVbnb4t8lLu5w=
Subject: Re: [PATCH net-next-2.6 1/17 v2] can: EG20T PCH: Separate
 Interface Register(IF1/IF2)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        andrew.chih.howe.khor@intel.com, qi.wang@intel.com,
        margie.foster@intel.com, yong.y.wang@intel.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com
In-Reply-To: <4CECEC85.1050009@pengutronix.de>
References: <4CECBFE3.8030402@dsn.okisemi.com>
	 <4CECEC85.1050009@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 11:54:25 +0100
Message-ID: <1290596065.3464.30.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 24 novembre 2010 à 11:44 +0100, Marc Kleine-Budde a écrit :
> On 11/24/2010 08:33 AM, Tomoya MORINAGA wrote:
> > Separate interface register from whole of register structure.
> > CAN register of Intel PCH EG20T has 2 sets of interface register.
> > To reduce whole of code size, separate interface register.
> > As a result, the number of function also can be reduced.
> 
> I failed to apply your series to david's net-2.6/master. Please resubmit.
> 
> > Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> > ---
> >  drivers/net/can/pch_can.c |  442 ++++++++++++++++++++-------------------------
> >  1 files changed, 198 insertions(+), 244 deletions(-)
> > 
> > diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> > index 238622a..143f100 100644
> > --- a/drivers/net/can/pch_can.c
> > +++ b/drivers/net/can/pch_can.c
> > @@ -102,6 +102,9 @@
> >  #define PCH_MSK_CTRL_IE_SIE_EIE	0x07
> >  #define PCH_COUNTER_LIMIT	10
> >  
> > +#define PCH_RX_IFREG			0
> > +#define PCH_TX_IFREG			1
> 
> Please make this enum _here_, not in a later patch.
> 

[then, huge part deleted, containing no review, spent some time to
discover this...]

Marc, could you please dont include the whole mail in your replies ?

We have a high Noise Rate on this topic already.

Thanks


