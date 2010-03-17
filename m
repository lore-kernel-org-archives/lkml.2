Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab0CQPk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:40:58 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:54508 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752831Ab0CQPk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:40:56 -0400
Subject: Re: checkpatch false positive
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1268839535.1652.43.camel@Joe-Laptop.home>
References: <1268823629.1999.9.camel@localhost>
	 <1268839535.1652.43.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 15:40:54 +0000
Message-ID: <1268840454.1999.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 08:25 -0700, Joe Perches wrote:
> On Wed, 2010-03-17 at 11:00 +0000, Richard Kennedy wrote:
> > I'm getting this error from checkpatch which is a false positive AFAICT.
> > I don't see any other way to code this macro so maybe this rule
> > shouldn't apply?.
> > 
> > 	ERROR: space prohibited before open square bracket '['
> > 	#24: FILE: drivers/staging/wlan-ng/p80211wext.c:1685:
> > 	+#define IW_IOCTL(x) [(x)-SIOCSIWCOMMIT]
> 
> While true that this is a false positive, hiding array indexing
> brackets in a macro doesn't seem a good idea.
> 
> Maybe it'd be better to move the brackets to the use?
> 
> 
err maybe ;)

I copied it from driver/net/wireless/ipw2x00/ipw2200.c 

It just reduces typing when initialising the array :-

	#define IW_IOCTL(x) [(x)-SIOCSIWCOMMIT]
	static iw_handler p80211wext_handlers[] = {
		IW_IOCTL(SIOCSIWCOMMIT) = (iw_handler) p80211wext_siwcommit,
		...

Oh, having quickly looked at wireless.h, I see there is already a macro
IW_IOCTL_IDX so I guess I should have used that!

would something like this be better?

	static iw_handler p80211wext_handlers[] = {
		[IW_IOCTL_IDX(SIOCSIWCOMMIT)] = (iw_handler) p80211wext_siwcommit,
		...

regards
Richard


