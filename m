Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab0FBV7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:59:54 -0400
Received: from s12.ALPHA-c2.vectant.ne.jp ([222.230.51.12]:39509 "EHLO
	s12.ALPHA-c2.vectant.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758682Ab0FBV7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:59:53 -0400
Message-Id: <201006022157.AA00420@tamuki.linet.gr.jp>
From: TAMUKI Shoichi <tamuki@linet.gr.jp>
Date: Thu, 03 Jun 2010 06:57:01 +0900
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>, Andy Green <andy@warmcat.com>,
       TAMUKI Shoichi <tamuki@linet.gr.jp>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic: keep blinking in spite of long spin timer mode
In-Reply-To: <20100530065522.GA14556@basil.fritz.box>
References: <20100530065522.GA14556@basil.fritz.box>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thank you for the suggestion.

On Sun, 30 May 2010 08:55:22 +0200 Andi Kleen wrote:

> Thanks for this explanation, makes all sense.
> But should do these changes by default then, not with a parameter.

Hmm, that will not be acceptable since the control of blinking speed
becomes difficult with long spin timer mode.

However, I agree to your opinion that it is not the best answer to
prepare purposely a new parameter for such a rare situation.

> Changing the frequency is ok, the only requirement is that it is
> visible and different from the frequency kdb uses.

So, I changed that the time calls to mdelay will be automatically
switched to longer if the speed of blinking is slow enough.  The
kernel parameter (panic_longspin) becomes no longer necessary.

I will soon post the PATCH v2.

Regards,
TAMUKI Shoichi
