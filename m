Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093Ab0EZKZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:25:46 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:54459 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208Ab0EZKZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:25:45 -0400
MIME-Version: 1.0
In-Reply-To: <1274868593.5882.5185.camel@twins>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	 <201005242049.18920.rjw@sisk.pl> <87wrusvrqe.fsf@deeprootsystems.com>
	 <201005250138.16293.rjw@sisk.pl> <1274863655.5882.4875.camel@twins>
	 <AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	 <1274867106.5882.5090.camel@twins>
	 <AANLkTiksR3YozbBH0Iv5kNsQkEGKCH1APCvn_s6LkjV9@mail.gmail.com>
	 <1274868593.5882.5185.camel@twins>
Date: Wed, 26 May 2010 03:25:44 -0700
Message-ID: <AANLkTinuxCbeBmxIR7b_1OtrqQYJCamiDZJbnNTih1Fb@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>, felipe.balbi@nokia.com,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/26 Peter Zijlstra <peterz@infradead.org>:
> On Wed, 2010-05-26 at 03:06 -0700, Arve Hjønnevåg wrote:
>
>> I was not talking about our user-space code. Suspend has to be called
>> by a running thread, so at least one runqueue is not empty.
>
> But why would you need to suspend if the machine is fully idle?
>

I have never seen a system that is fully idle for hours or even minutes.

> Is it because you're using broken hardware that has lower power
> consumption in suspend state as in idle?
>

Initially, yes, but for shipping android phones, no.

> Couldn't you make the runtime-pm smarter and utilize the suspend states?
>

I don't think runtime-pm is relevant here. We don't use suspend to
power down devices that are not in use, we use suspend to enter system
power states that we cannot enter from idle, and on systems where the
same power state can be used from idle and suspend, we use suspend so
we can stay in the low power state for minutes to hours instead of
milliseconds to seconds.

-- 
Arve Hjønnevåg
