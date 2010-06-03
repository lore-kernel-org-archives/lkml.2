Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab0FCRfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:35:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38027 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab0FCRfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=l553ZBlm0uJjx1oBkrpD25yWILrLHKFu9giOlUn4K72fzGAod/ScqpLJTeselABWue
         ynN33Afg0vj34iDhDJOFMzUE+i4VJqSSmprpBqAFZzdsR6ra9+NSWvukIlOZQkXLeymc
         q80vxigTcZ/ZV1hWMhPZPcWmZUaIyquXnvauI=
Subject: Re: [PATCH] mmc: make sdhci work with ricoh mmc controller
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, adq_dvb@lidskialf.net,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
In-Reply-To: <20100603100510.37d02c2b@fido5>
References: <1275516180.30272.4.camel@maxim-laptop>
	 <1275527787-3783-1-git-send-email-maximlevitsky@gmail.com>
	 <20100603091113.7b1d6fc0@fido5> <1275582709.2563.19.camel@maxim-laptop>
	 <20100603093914.3397ac42@fido5>  <20100603100510.37d02c2b@fido5>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 20:35:31 +0300
Message-ID: <1275586531.2594.3.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 10:05 -0700, Philip Langdale wrote: 
> On Thu, 3 Jun 2010 09:39:14 -0700
> Philip Langdale <philipl@overt.org> wrote:
> 
> > > > 
> > > > Have you been able to establish if 4bit and high-speed operations
> > > > work correctly through the MMC controller? I note that you didn't
> > > > set SDHCI_CAN_DO_HISPD.
> > > Didn't test that yet, will do.
> > > I hope my MMCPlus card can do high-speed.
> > 
> > I should get a chance today to test this as well; I'll let you know
> > what I see.
> > 
> 
> Ok, I was able to try it out and setting HISPD works and 4bit seems
> to work too. My MMCplus cards run at the same speed with either
> controller.
I too confirm that.

However that suspend/resume race is tough one.
The problem seems that controller doesn't like both devices to be poked
at same time, and normally they won't, but here on resume both are
tested for a card, and this is done asynchronously by mmc core.

I will get to bottom of this sooner or later (I hope).

Best regards,
Maxim Levitsky

