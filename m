Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0FODPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 23:15:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64946 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab0FODPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 23:15:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=DGJJqwRRKpY14GonBbjbCCDvMEzfeXGon1iuwORvIwigYpS6pRBY3W7JwlUIYJbbKr
         fLHWLIfAHR8geZBzrHuVYIDRuMBqo9nkCr373vm/khBHy4CzVYY1wn/JsACa8Et+GDlC
         RjKDXNjY2ggn2GefazsHqU/sUwwHWBHQXzD+0=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH V2] matrix_keypad: add support for clustered irq
Date: Thu, 10 Jun 2010 12:32:43 -0700
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc2+; KDE/4.4.3; x86_64; ; )
Cc: Luotao Fu <l.fu@pengutronix.de>, Marek Vasut <marek.vasut@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <1274882226-19778-1-git-send-email-l.fu@pengutronix.de> <1274942634-31735-1-git-send-email-l.fu@pengutronix.de> <AANLkTikzzqx0mJM6cjqdm_n8i3F4lCdaAf2xkpQ_havX@mail.gmail.com>
In-Reply-To: <AANLkTikzzqx0mJM6cjqdm_n8i3F4lCdaAf2xkpQ_havX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006101232.43598.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 27, 2010 08:14:50 am Eric Miao wrote:
> On Thu, May 27, 2010 at 2:43 PM, Luotao Fu <l.fu@pengutronix.de> wrote:
> > This one adds support of a combined irq source for the whole matrix keypad.
> > This can be useful if all rows and columns of the keypad are e.g. connected
> > to a GPIO expander, which only has one interrupt line for all events on
> > every single GPIO.
> >
> > Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
> 
> I feel OK. Acked-by: Eric Miao <eric.y.miao@gmail.com>
> 
> > ---
> > V2 Changes:
> > * create separate functions for suspend/resume calls.
> > * add bool flag to signal enable/disable state of all gpios.
> > * add spinlock to suspend and resume callbacks.

The spinlock is not needed, it should be OK to get interrupted in the middle
of setting up wakeup sources. The enable/disable irq is different as if we
get interrupted in the middle of the process our counters will get messed
up.

Fixed a few compile warnings and applied for .36.

Thanks.

-- 
Dmitry
