Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab0D3REn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:04:43 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:38971 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007Ab0D3RE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:04:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vPWTiHzt/lIX2zsmwKqezSRy3z1inqbYV9zQbmMvjkWrkmqM1BiKJjLifyIIt4KpYE
         5wfupRQo20a2Imb6ZJI9y6biUMtqVEk4IB3Hzohj6wBoiF1DX0R8oVIs6hhFaQONsnoM
         Z7ucTwnADN/kt6AJjqAXDve8Pf8+99uoDngJg=
MIME-Version: 1.0
In-Reply-To: <20100427221705.1628375b.akpm@linux-foundation.org>
References: <4BD7C240.5050800@renesas.com>
	 <20100427221705.1628375b.akpm@linux-foundation.org>
Date: Fri, 30 Apr 2010 12:51:37 +0900
Message-ID: <o2uaec7e5c31004292051yff981cebg3bd05e2684036ae4@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] MMC:Add support MMCIF for SuperH
From: Magnus Damm <magnus.damm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yusuke Goda <yusuke.goda.sx@renesas.com>, ben@decadent.org.uk,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks for your review!

On Wed, Apr 28, 2010 at 11:17 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 28 Apr 2010 14:06:08 +0900 Yusuke Goda <yusuke.goda.sx@renesas.com> wrote:
>
>> +     time = wait_event_interruptible_timeout(host->intr_wait,
>> +                     host->wait_int == 1 ||
>> +                     host->sd_error == 1, host->timeout);
>> +     if (host->wait_int != 1 && (time == 0 || host->sd_error != 0))
>> +             return sh_mmcif_error_manage(host);
>
> wait_event_interruptible_timeout() will return early with -ERESTARTSYS
> if the calling process gets signalled (eg, ^C was hit).
>
> The driver uses wait_event_interruptible_timeout() rather a lot and the
> two sites I looked at seem to handle the signal_pending() case
> correctly.
>
> But incorrectly handling signals with interruptible waits is a
> frequently-occurring error in drivers.  Did you deliberately cater for
> this case, and have you runtime tested it?

My plan is to use this driver on SH-Mobile ARM (sh7372), and I'd be
happy to fix up the driver to become a bit less non-standard wrt
blocking compared to the other MMC host drivers. Is it possible that
Goda-san fixes up whatever minor bits that need rework and that you
pick up at that point?

I'd like to rework the MMCIF blocking code and perhaps also add
dmaengine support as feature patches on top of Goda-sans work if
that's ok with you. Better PM is also on the TODO. Not sure if any of
these features will make it in time for the 2.6.35 merge window
though.

It would be very useful to have the MMCIF driver as-is in 2.6.35
mainline to begin with if possible. Or do you think the driver needs
to be reworked more before that can happen?

Thanks,

/ magnus
