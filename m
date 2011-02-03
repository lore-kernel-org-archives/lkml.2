Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab1BCIFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 03:05:22 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:60945 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753207Ab1BCIFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 03:05:21 -0500
X-Authenticated: #1101344
X-Provags-ID: V01U2FsdGVkX1+mJuwy6oemJvAgIOH+2ew5ryj3+h2z/xHv+EBYqa
	0bus/n11VaVZIb
From: Markus Kohm <jabber@gmx.org>
Organization: KOMA
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86, mtrr: avoid MTRR reprogramming on BP during boot on UP platforms
Date: Thu, 3 Feb 2011 09:05:13 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-default; KDE/4.4.4; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, trenn@novell.com,
        Rafael Wysocki <rjw@novell.com>,
        Venkatesh Pallipadi <venki@google.com>
References: <1296694975.4418.402.camel@sbsiddha-MOBL3.sc.intel.com>
In-Reply-To: <1296694975.4418.402.camel@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102030905.14826@komascript.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote on Thursday 03 February 2011:
>  diff --git a/arch/x86/kernel/cpu/mtrr/main.c
>  b/arch/x86/kernel/cpu/mtrr/main.c index 01c0f3e..4fe5ebc 100644
>  --- a/arch/x86/kernel/cpu/mtrr/main.c
>  +++ b/arch/x86/kernel/cpu/mtrr/main.c
>  @@ -793,13 +793,21 @@ void set_mtrr_aps_delayed_init(void)
>   }
>   
>   /*
>  - * MTRR initialization for all AP's
>  + * Delayed MTRR initialization for all AP's
>    */
>   void mtrr_aps_init(void)
>   {
>          if (!use_intel())
>                  return;
>   
>  +       /*
>  +        * Check if someone has requested the delay of AP MTRR
>  initialization, +        * by doing set_mtrr_aps_delayed_init(), prior to
>  this point. If not, +        * then we are done.
>  +        */
>  +       if (!mtrr_aps_delayed_init)
>  +               return;
>  +
>          set_mtrr(~0U, 0, 0, 0);
>          mtrr_aps_delayed_init = false;
>   }

ACK

I've tested with kernel 2.6.38-rc3. The hard hang regression is fixed.

Thank you very much!
