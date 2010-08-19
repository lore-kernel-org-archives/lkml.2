Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0HSOfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:35:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36320 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab0HSOfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Ras5H/12BodE9+GI7mItt7qrK7BBhfRer8FxhON2bURdrSnpN/3dtlwcaJptQ2Vw1S
         ey1W4apOIjeJPGqMyjsHLTeORjfYAROY+wbitXZmHcHXywAmbf8gaeLqG1zxbnDPQx+Z
         uGaK6AJ/g15JA31JYzRFzhDYFilGhE6LypeSw=
MIME-Version: 1.0
In-Reply-To: <201008190001.11342.rjw@sisk.pl>
References: <201008190001.11342.rjw@sisk.pl>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 18 Aug 2010 18:00:47 -0700
X-Google-Sender-Auth: Ds4KCNnrA-hxGTeb0m3mUXeBB9E
Message-ID: <AANLkTi=S3JE=1J9xQtBAN5hHTqGSfohi4vL82iZHMWp+@mail.gmail.com>
Subject: Re: [Regression, 2.6.36-rc1] ath9k resume problem on Acer Ferrari One
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 3:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> While testing 2.6.36-rc1 (with a couple of fixes on top)

Which couple of fixes?

> I noticed that the ath9k
> driver didn't work after resume from suspend to RAM.

To rule out if its an ath9k issue you can try
compat-wireless-2.6.36-rc1 from here:

http://wireless.kernel.org/en/users/Download/stable/

and install it on an older kernel, you can use ./scripts/driver-select
to only enable ath9k to compile.

I've been using pm-suspend on this release for a few days now without
any issue but I am using an AR9003 chipset. What chipset are you
using? Can you provide the dmesg output upon module load?

>  An attempt to unload the
> driver using rmmod caused the BUG_ON() in kernel/workqueue.c:2844 to trigger.

That's a bug, a regression likely.

> I wonder if that regression is a result of the recent workqueue changes?

Yeah very likely.

  Luis
