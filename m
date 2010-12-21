Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab0LUHXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 02:23:16 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38602 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab0LUHXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 02:23:14 -0500
Date: Tue, 21 Dec 2010 08:23:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Seblu <seblu@seblu.net>
Cc: Zhang Rui <rui.zhang@intel.com>, "Brown, Len" <len.brown@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI battery: Fix sysfs oops when removing battery
Message-ID: <20101221072309.GA32278@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, Seblu <seblu@seblu.net>,
	Zhang Rui <rui.zhang@intel.com>, "Brown, Len" <len.brown@intel.com>,
	lkml <linux-kernel@vger.kernel.org>
References: <20101219130001.GB5790@liondog.tnic>
 <1292896861.2300.288.camel@rui>
 <AANLkTi=0ZU_eHQpUHwny=TZn31iH0GJq7tCXhPqs3WE4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTi=0ZU_eHQpUHwny=TZn31iH0GJq7tCXhPqs3WE4@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 04:24:26AM +0100, Seblu wrote:
> On Tue, Dec 21, 2010 at 3:01 AM, Zhang Rui <rui.zhang@intel.com> wrote:
> > On Sun, 2010-12-19 at 21:00 +0800, Borislav Petkov wrote:
> >> Hi guys,
> >>
> >> I get the oops below on 37-rc6. Here's a possible fix:
> >>
> > does this happen every time when you unload the battery driver?
> >
> on my laptop (dell e6410), with 4 tests, this append every times.

Yes, it happens every time here too. The explanation for that is simple:
according to the oops, this is on the path of acpi_ev_notify_dispatch()
which looks like it handles ACPI events and since removing the battery
or changing of the power supply or similar is one such event, we do a
state update.

-- 
Regards/Gruss,
    Boris.
