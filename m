Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab1ATEBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 23:01:11 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:35376 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755129Ab1ATEBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 23:01:10 -0500
Date: Thu, 20 Jan 2011 06:01:00 +0200
From: Felipe Balbi <balbi@ti.com>
To: Yang Ruirui <ruirui.r.yang@tieto.com>
Cc: Felipe Balbi <balbi@ti.com>, Yang Ruirui R <ruirui.r.yang@tietoenator.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Felipe Balbi <felipe.balbi@nokia.com>,
        Heikki Krogerus <ext-heikki.krogerus@nokia.com>,
        Tejun Heo <tj@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Hema HK <hemahk@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb otg: use atomic notifier instead of blocking
 notifier
Message-ID: <20110120040059.GA2389@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110119092011.GA23624@darkstar>
 <20110119104032.GJ2505@legolas.emea.dhcp.ti.com>
 <20110120020638.GA24396@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120020638.GA24396@darkstar>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 10:06:38AM +0800, Yang Ruirui wrote:
> Actually I does not found where notifiers are used in these files except
> langwell_otg
> 
> For langwell_otg.c there's a wrapper struct named "intel mid_otg_xceiv"
> in include/linux/usb/intel_mid_otg.h, it use an atomic notifier for
> interrupt context.
> 
> So I think we'd better write another patch to make it use general
> otg_transceiver for notifier or just keep current code. What's your opinion?

I'm not the maintainer but I would rather see it using the notifier on
the otg_transceiver structure, and later add the support for the other
transceivers too.

-- 
balbi
