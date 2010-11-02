Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938751Ab0KBGbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 02:31:08 -0400
Received: from smtp.nokia.com ([147.243.1.47]:37685 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab0KBGa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 02:30:58 -0400
Subject: Re: [RFC PATCH] device-core: sysfs open - close notify
From: Onkalo Samu <samu.p.onkalo@nokia.com>
Reply-To: samu.p.onkalo@nokia.com
To: ext Alan Cox <alan@linux.intel.com>
Cc: Ming Lei <tom.leiming@gmail.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "hmh@hmh.eng.br" <hmh@hmh.eng.br>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101101171126.1194e2b0@linux.intel.com>
References: <1288529170-28890-1-git-send-email-samu.p.onkalo@nokia.com>
	 <AANLkTikRSF-4o=Jnyg2_Wa4gg7E+s_tM9ZD3g+f7hyWm@mail.gmail.com>
	 <20101101171126.1194e2b0@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia Oyj
Date: Tue, 02 Nov 2010 08:30:08 +0200
Message-ID: <1288679408.2080.18.camel@noppispoppis.nmp.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-01 at 18:11 +0100, ext Alan Cox wrote:
> > Your patch may cause many unnecessary memory waste because
> > most of drivers does not need attribute file .open/.close notifier.
> 
> Firstly there are not that many driver objects in a small system so it
> wouldn't take that much to shift the balance the other way. Secondly
> its becoming clear that every time a driver goes to runtime pm these
> issues come up - even with things like configuration values for drivers
> that need to wake the hardware and then silence it.
> 
> So the whole sysfs/open thing is going to keep haunting us with runtime
> pm, the question is where to put the callbacks so we don't bloat stuff.
> Clearly not per attribute or per sysfs node. One possibility would be
> with the runtime pm stuff, but that would need a clean reliable way to
> go sysfs->device->runtime_pm
> 
> There are also obvious hackish ways to handle it like passing a 0
> length read to indicate close etc - they save memory but they are
> asking for problems in future.
> 

Memory footprint could be minimized by combining separate open close
functions to one like sysfs_open_close_notify and the actual operation
would be a call parameter. But is that hackish?

And perhaps some flags could be used to indicate which attributes trigs
the open / close notification.

-Samu

 


