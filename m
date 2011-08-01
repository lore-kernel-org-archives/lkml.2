Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1HAVLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:11:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49900 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1HAVLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:11:30 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/10] lis3lv02d: avoid divide by zero due to unchecked
Date: Mon, 1 Aug 2011 23:11:17 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-wl+; KDE/4.6.5; x86_64; ; )
Cc: =?iso-8859-1?q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>,
        Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org
References: <4E2D8858.8000900@tremplin-utc.net> <4E2D88C7.30409@tremplin-utc.net> <20110801132906.2d4cd28e.akpm@linux-foundation.org>
In-Reply-To: <20110801132906.2d4cd28e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108012311.17881.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 01, 2011 10:29:06 PM Andrew Morton wrote:
> On Mon, 25 Jul 2011 17:16:23 +0200
> __ric Piel <eric.piel@tremplin-utc.net> wrote:
> 
> > +static int lis3lv02d_get_pwron_wait(struct lis3lv02d *lis3)
> > +{
> > +	int div = lis3lv02d_get_odr();
> > +
> > +	if (WARN_ONCE(div == 0, "device returned spurious data"))
> > +		return -ENXIO;
> > +
> > +	/* LIS3 power on delay is quite long */
> > +	msleep(lis3->pwron_delay / div);
> > +	return 0;
> > +}
> 
> The WARN_ONCE may not be very useful.  The user gets worried, might
> report it (often to a distro, not to you!).  But we won't actually *do*
> anything with the information?
The sensor is used to park the hdd in case of an "accident". However,
if the sensors is not working, the user should at least get a WARN
that something is very wrong, right?

Regards,
	Chr
