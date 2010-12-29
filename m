Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab0L2SeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 13:34:05 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33252 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0L2SeC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 13:34:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=A7RnVBVR6NRENzgoIk2bezRFpEdf2IlPDlAlgdcCqr9AnVW/R1tRhoGTATSlebjsth
         vJMCqcfQGWJ6fsRXPPHdPbSdRf+/I2mg0lF2rSfVgPsoR6JBuZmssXawVIlKJ3Vvj99u
         DQ9fbOsbob77rEbiv+IT7bQEcAJzJ/0j9SC7A=
MIME-Version: 1.0
In-Reply-To: <20101222141947.94322b9c.akpm@linux-foundation.org>
References: <20101219190828.A6C189D401C@zog.reactivated.net>
	<20101222141947.94322b9c.akpm@linux-foundation.org>
Date: Wed, 29 Dec 2010 18:34:01 +0000
X-Google-Sender-Auth: qW3owmfLaAgy6FaDdxcEGlhhD38
Message-ID: <AANLkTinMXCmmR1T74JqNJC_HsWwuqhuYbj0fdJHMQgTh@mail.gmail.com>
Subject: Re: [PATCH v3] rtc-cmos: fix suspend/resume
From: Daniel Drake <dsd@laptop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, pgf@laptop.org, rjw@sisk.pl,
        stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 December 2010 22:19, Andrew Morton <akpm@linux-foundation.org> wrote:
> It's unclear what the user-visible effects of this bug were.  Machine
> fails to suspend?  RTC loses its brains on resume?  Something else?
>
> That's really important information for a bugfix's changelog.  Please
> never omit it.

Sorry about that.
After looking in more detail, I agree with Paul. This bug only affects
setups where no PNP RTC is available, or where CONFIG_PNP is disabled.
It also affects OLPC's coming-soon addition of an XO-specific RTC
driver.

So, a clear and simple fix, but not a wide-reaching bug in the first place.
2.6.38 would be fine, no real need for -stable backporting IMO.

Thanks,
Daniel
