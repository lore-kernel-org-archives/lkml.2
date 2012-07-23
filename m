Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab2GWR7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:59:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56568 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab2GWR6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:58:51 -0400
Message-ID: <500D90C7.9000903@gmail.com>
Date: Mon, 23 Jul 2012 19:58:31 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Sven Neumann <s.neumann@raumfeld.com>, Olof Johansson <olof@lixom.net>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: eeti_ts: Mark as CONFIG_BROKEN
References: <1333777207-4151-1-git-send-email-olof@lixom.net> <20120407070206.GA17623@core.coreip.homeip.net> <4F8089A9.6080704@raumfeld.com> <20120503043651.GA11830@core.coreip.homeip.net> <20120713070102.GA2223@core.coreip.homeip.net> <500561AF.9090901@gmail.com> <5008296C.5070709@gmail.com> <20120723165120.GB26577@core.coreip.homeip.net>
In-Reply-To: <20120723165120.GB26577@core.coreip.homeip.net>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.07.2012 18:51, Dmitry Torokhov wrote:
> On Thu, Jul 19, 2012 at 05:36:12PM +0200, Daniel Mack wrote:

>> Ok, finally I found some time. In general, the patch works fine. The
>> only detail I had to amend was the irqflags, which were changed from
>> IRQF_TRIGGER_RISING/IRQF_TRIGGER_FALLING to
>> IRQF_TRIGGER_HIGH/IRQF_TRIGGER_LOW, which doesn't work as the PXA can't
>> deal with level-based IRQs. Changing this back to RISING/FALLING makes
>> the driver work again.
> 
> Hmm, but that would mean we need to restore reading the data in open()
> to make sure we re-arm IRQ in case somebody touched the screen before it
> was opened by userspace...

Hmm, right, that was the reason why I put it there in the first place.
Thanks for the heads-up. Would you do it? Want me to?


Daniel
