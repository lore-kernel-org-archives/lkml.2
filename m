Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab1LTTnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:43:55 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55986 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab1LTTnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:43:47 -0500
MIME-Version: 1.0
In-Reply-To: <20111220111935.GE31842@legolas.emea.dhcp.ti.com>
References: <1323990310-11905-1-git-send-email-felipe.contreras@gmail.com>
	<1323990310-11905-2-git-send-email-felipe.contreras@gmail.com>
	<20111219081137.GF3146@legolas.emea.dhcp.ti.com>
	<CAMP44s2pbLRHB2ko9t-zQEpTFw=TaCS9b_qRmvAobgxeJ9WrCw@mail.gmail.com>
	<20111220111935.GE31842@legolas.emea.dhcp.ti.com>
Date: Tue, 20 Dec 2011 21:43:45 +0200
Message-ID: <CAMP44s1m9oXpiw506kE6JJn5xO+oCRL8B0UixUf4X=Ew00=wHA@mail.gmail.com>
Subject: Re: [PATCH 1/3] usb: musb: fix pm_runtime mismatches
From: Felipe Contreras <felipe.contreras@gmail.com>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 1:19 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Mon, Dec 19, 2011 at 10:20:09PM +0200, Felipe Contreras wrote:
>> On Mon, Dec 19, 2011 at 10:11 AM, Felipe Balbi <balbi@ti.com> wrote:
>> > On Fri, Dec 16, 2011 at 01:05:08AM +0200, Felipe Contreras wrote:
>> >> Properly call pm_runtime_put() afer pm_runttime_get() on errors.
>> >>
>> >> Untested.
>> >
>> > sorry, but I'm not applying untested patches. I need someone to give a
>> > Tested-by.
>>
>> I'm pretty sure most people don't test the exit paths, but fine, don't
>> apply them. Who needs power management anyway.
>
> if it wasn't tested you can't claim $SUBJECT makes PM magically work.

It's clear from the code, no need to test to see that pm_runtime_get()
is called but not pm_runtime_put(), thus the device remains active,
thus PM would not work after that.

-- 
Felipe Contreras
