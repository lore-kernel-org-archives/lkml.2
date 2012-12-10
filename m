Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab2LJWV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:21:59 -0500
Received: from wren.arvixe.com ([50.97.138.99]:57598 "EHLO wren.arvixe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab2LJWV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:21:57 -0500
Message-ID: <1355178112.2897.22.camel@localhost>
Subject: Re: [PATCH 4/5] rtl8712: replace min with min_t
From: Przemo Firszt <przemo@firszt.eu>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        greg@kroah.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Dec 2012 22:21:52 +0000
In-Reply-To: <20121210094108.GQ6568@mwanda>
References: <1355048110-10859-1-git-send-email-przemo@firszt.eu>
	 <1355048110-10859-4-git-send-email-przemo@firszt.eu>
	 <20121210094108.GQ6568@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2 (3.6.2-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - wren.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
X-Get-Message-Sender-Via: wren.arvixe.com: authenticated_id: przemo@firszt.eu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2012-12-10, pon o godzinie 12:41 +0300, Dan Carpenter pisze:
> On Sun, Dec 09, 2012 at 10:15:09AM +0000, Przemo Firszt wrote:
> > A clean up change suggested by checkpatch.pl
> > 
> > Signed-off-by: Przemo Firszt <przemo@firszt.eu>
> > ---
> >  drivers/staging/rtl8712/rtl871x_ioctl_linux.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> > index cdb51d7..b131b61 100644
> > --- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> > +++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> > @@ -188,8 +188,7 @@ static inline char *translate_scan(struct _adapter *padapter,
> >  	/* Add the ESSID */
> >  	iwe.cmd = SIOCGIWESSID;
> >  	iwe.u.data.flags = 1;
> > -	iwe.u.data.length = (u16)min((u16)pnetwork->network.Ssid.SsidLength,
> > -			    (u16)32);
> > +	iwe.u.data.length = min_t(u16, pnetwork->network.Ssid.SsidLength, 32);
> 
> pnetwork->network.Ssid.SsidLength is a u32 so it would be better to
> not truncate the upper bits away.  It's not going to cause a
> problem, but its slightly messy.
> 
> This is a common problem where people take the type of
> iwe.u.data.length and cast to that instead of considering the types
> for the data they are comparing.
> 
Dan,
Thanks for the comment!

iew.u.data.length is __u16

min_t is defined as:
#define min_t(type, x, y) ({                    \
        type __min1 = (x);                      \
        type __min2 = (y);                      \
        __min1 < __min2 ? __min1: __min2; })

If I understand you correctly I should use this:

iwe.u.data.length = min_t(u32, pnetwork->network.Ssid.SsidLength, 32);

the result of min_t is u32, but iwe.u.data.lenght is __u16

Is that correct?
-- 
Kind regards,
Przemo Firszt


