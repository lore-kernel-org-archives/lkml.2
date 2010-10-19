Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab0JSXNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 19:13:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50416 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab0JSXNE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 19:13:04 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinZ2+ocJCfUpT15Ow3J9XBa-8XWnVC3gDDJ7s-v@mail.gmail.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287387875-14168-4-git-send-email-ohad@wizery.com> <87r5fmxghm.fsf@deeprootsystems.com>
 <AANLkTinZ2+ocJCfUpT15Ow3J9XBa-8XWnVC3gDDJ7s-v@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 19 Oct 2010 17:12:43 -0600
X-Google-Sender-Auth: e9sc365fb-MlHirOrpnO_61kFJU
Message-ID: <AANLkTimTDCbLP+EeUeo35re0FrMvqV3ozU+v7DZXr_p3@mail.gmail.com>
Subject: Re: [PATCH 3/3] omap: add hwspinlock device
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        akpm@linux-foundation.org, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Simon Que <sque@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 3:02 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Tue, Oct 19, 2010 at 7:03 PM, Kevin Hilman
> <khilman@deeprootsystems.com> wrote:
>>> +postcore_initcall(hwspinlocks_init);
>>
>> Any reason this needs to be a postcore_initcall?  Are there users of
>> hwspinlocks this early in boot?
>
> i2c-omap, which is subsys_initcall (the I2C bus is shared between the
> A9 and the M3 on some OMAP4 boards).
>
> And to allow early board code to reserve specific hwspinlock numbers
> for predefined use-cases, we probably want to be before arch_initcall.

Man. this is getting ugly.  I think we need to discuss how to solve
this at the Plumbers micro-conference. It kind of fits in with the
whole embedded (ab)use of the device model topic anyway. Actually,
this particular case isn't bad, but the moving of i2c and spi busses
to an earlier initcall is just band-aiding the real problem of driver
probe order dependencies.

g.
