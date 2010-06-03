Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140Ab0FCBWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 21:22:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50308 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab0FCBWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 21:22:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=H/SJMB0ZaQjT8VW1T/zXb+ajCwspGmFPAazTs6AnftmXfx0FWo4TEyv/wpiy8ybsyP
         7s3Jq7wOEX+f8cQeGznfwCi8bzxr8B/liUJGE2pn0Zv5jijbFrZI3AVRX/qy614BjcK6
         uf99P9vY0Yho3KDyCQ4vrHN4LioryJm9lXPK0=
Subject: Re: strange problem with ricoh-mmc
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1275516180.30272.4.camel@maxim-laptop>
References: <1275505018.4215.10.camel@maxim-laptop>
	 <04b98a3f757587ee9b72f2e28e257b50@localhost>
	 <1275509965.6277.5.camel@maxim-laptop>
	 <b7d3349cdb8e4c118d617ef9df57bf69@localhost>
	 <1275516180.30272.4.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 04:22:27 +0300
Message-ID: <1275528147.2664.16.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 01:03 +0300, Maxim Levitsky wrote: 
> On Wed, 2010-06-02 at 16:42 -0400, Philip Langdale wrote: 
> > On Wed, 02 Jun 2010 23:19:25 +0300, Maxim Levitsky
> > <maximlevitsky@gmail.com> wrote:
> > > 
> > > Thanks.
> > > I some future I maybe consider reverse engineering  the MMC controller.
> > 
> > Someone actually did, if you dig back through the SDHCI mailing list. It's
> > apparently almost identical to SDHCI with the Cap flags not set properly.
> This is just great.
> 
> Maybe its even possible to make SDHCI use it.
> 
> > 
> > http://list.drzeus.cx/pipermail/sdhci-devel/2007-December/002085.html
> > 
> > Still, even if we got it working properly, it would be rather less elegant
> > than what we have today, modulo hardware freaking out as you are
> > experiencing...
> The curreent version is very elegant....
> Like once you resume the system, insert card and is out of ideas of what
> to do next....
> 
> Thank you very much!
The patch I just send works here almost perfect.
Well, the asynchronous tries now to resume both sdhci devices in
parallel, and that makes them very unhappy.
Simple solution is just to exclude these two devices from async suspend,
but it seem not to work. I asked that at linux-pm. I am sure that will
be fixed. Anyway disabling async suspend works around this issue.

I wish I knew that this 'proprietary' mmc controller is just a SDHCI in
disguise before....

Big thanks to 'Andrew de Quincey' for this work.

Best regards,
Maxim Levitsky

