Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0EZWVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:21:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8748 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab0EZWVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:21:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=WSVawS5HGid0JsTSRkpc7/REJEQOZadScSYyb9DfbZty05MubrRgYeDj3mjUsG32+
	LH36Ul3fxkkpW6q6XAS2Q==
MIME-Version: 1.0
In-Reply-To: <d1278473-1065-4607-98e0-67f2b985ec15@default>
References: <d1278473-1065-4607-98e0-67f2b985ec15@default>
Date: Wed, 26 May 2010 15:21:10 -0700
Message-ID: <AANLkTim1_8Rf0fPfycE92z5CAXpLXYga93A5qTxgXjqz@mail.gmail.com>
Subject: Re: tsc reliability for Intel Core 2 Duo "Conroe"
From: Venkatesh Pallipadi <venki@google.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 10:41 AM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:
> Looking through code following up on the separate TSC-related
> thread, I noticed that my Intel Core 2 Duo "Conroe" box
> is determined to have an unstable TSC, so falls back
> to clocksource==hpet.
>
> While a Conroe has X86_FEATURE_CONSTANT_TSC and not
> X86_FEATURE_NONSTOP_TSC, a Conroe is only able to enter
> C0 and C1 (unlike its sister Intel Core 2 Duo processor
> "Merom" which can enter C0-C3).
>
> I was under the impression (possibly from an earlier kernel
> version?) that tsc_constant PLUS inability to enter deep-C
> states would result in an acceptably stable TSC to use
> as a clocksource (assuming it passes a TSC warp test).
>
> So is this a bug?  Or is my impression incorrect?
>
> See tsc_check_state() in drivers/acpi/processor_idle.c.
> I can submit a patch, but wanted to check first.

Adding Len.

tsc_check_state(0 should only mark TSC unstable when state > C1 and
!NONSTOP_TSC. Are you seeing TSC marked even with only C1?

Or may be you are hitting the bug in acpi_pad.c that marks TSC
unstable more aggressively. I recently sent out a patch for that here
-
https://patchwork.kernel.org/patch/100633/

Thanks,
Venki
