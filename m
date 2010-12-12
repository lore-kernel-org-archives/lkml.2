Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab0LLK5t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 05:57:49 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39594 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0LLK5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 05:57:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xItQioqzxELkCAH/4NHXyLGIkHRF4akI1ZX6Jh48s2t/qRUc70Ovfs7nzUyS0PdQCd
         wuAmimE76NRcT06ttpZQlKm24/PYS6aRlPDP82R+x1IGN4j8IlcAjl6MDNYgWdu8xerh
         P7PHGPa+n+KLeHCfAmTYXYJdeacv5/AX7jK7U=
MIME-Version: 1.0
In-Reply-To: <20101211192320.GA24430@void.printf.net>
References: <AANLkTi=0RtvsGX+Q3goL3mdG6oKeNidYtiudTZ8ZTpRP@mail.gmail.com>
	<20101208115510.GD10998@console-pimps.org>
	<AANLkTi=KqOa-MRQiptCtZGvoafRCgULfE3QFs=hmGpdi@mail.gmail.com>
	<AANLkTi=PpTi1_JO9Q=ph7w9Jim8iXMf9LbCfmEkWuo-h@mail.gmail.com>
	<20101209064751.GA21128@void.printf.net>
	<AANLkTimMgrawcndvUTYYjq9BGFqs-sbRsZkwVQ0Uvhvb@mail.gmail.com>
	<20101209160157.GA28586@void.printf.net>
	<AANLkTim3Rj2tTbqvT8nM4L=p=Wx8bdOnGq=EDv+cs02g@mail.gmail.com>
	<20101211192320.GA24430@void.printf.net>
Date: Sun, 12 Dec 2010 10:57:44 +0000
Message-ID: <AANLkTin5aVPz5Y=jS89V00XS=rje3gqeUb2VTYt2A_9=@mail.gmail.com>
Subject: Re: [PATCH] dw_mmc: Add Synopsys DesignWare mmc host driver.
From: Will Newton <will.newton@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 7:23 PM, Chris Ball <cjb@laptop.org> wrote:
> Hi Will,
>
> On Thu, Dec 09, 2010 at 05:24:26PM +0000, Will Newton wrote:
>> This adds the mmc host driver for the Synopsys DesignWare mmc
>> host controller, found in a number of embedded SoC designs.
>>
>> Signed-off-by: Will Newton <will.newton@imgtec.com>
>> Reviewed-by: Matt Fleming <matt@console-pimps.org>
>
> Running a test build on ARM fails:
>
> drivers/mmc/host/dw_mmc.c: In function ‘dw_mci_push_data64’:
> drivers/mmc/host/dw_mmc.c:985: error: implicit declaration of function ‘__raw_writeq’
> drivers/mmc/host/dw_mmc.c: In function ‘dw_mci_pull_data64’:
> drivers/mmc/host/dw_mmc.c:998: error: implicit declaration of function ‘__raw_readq’
>
> because arch/arm doesn't implement raw versions of these 64-bit accesses.
> I'm surprised that this driver hasn't been compiled on ARM before!  What

That particular bit of code has been added since it was last built for
arm. Our architecture can do 64bit accesses so we implement readq.
Unfortunately there doesn't seem to be a sane way to conditionalize
code for architectures that have or don't have readq, so I suspect
I'll have to just remove that branch of the if statement for now.

> kind of arch are you testing on?  Do you have any ARM hardware (lpc313x?)
> to verify the driver on?

Our architecture is not merged into mainline yet (although I am
working on that). I don't have an lpc313x board but I would be happy
to work on this code with anyone who does.
