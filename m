Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab0KASHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:07:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:18659 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab0KASHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:07:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,275,1286175600"; 
   d="scan'208";a="343155408"
Date: Mon, 1 Nov 2010 17:11:26 +0000
From: Alan Cox <alan@linux.intel.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>, gregkh@suse.de, hmh@hmh.eng.br,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] device-core: sysfs open - close notify
Message-ID: <20101101171126.1194e2b0@linux.intel.com>
In-Reply-To: <AANLkTikRSF-4o=Jnyg2_Wa4gg7E+s_tM9ZD3g+f7hyWm@mail.gmail.com>
References: <1288529170-28890-1-git-send-email-samu.p.onkalo@nokia.com>
	<AANLkTikRSF-4o=Jnyg2_Wa4gg7E+s_tM9ZD3g+f7hyWm@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Your patch may cause many unnecessary memory waste because
> most of drivers does not need attribute file .open/.close notifier.

Firstly there are not that many driver objects in a small system so it
wouldn't take that much to shift the balance the other way. Secondly
its becoming clear that every time a driver goes to runtime pm these
issues come up - even with things like configuration values for drivers
that need to wake the hardware and then silence it.

So the whole sysfs/open thing is going to keep haunting us with runtime
pm, the question is where to put the callbacks so we don't bloat stuff.
Clearly not per attribute or per sysfs node. One possibility would be
with the runtime pm stuff, but that would need a clean reliable way to
go sysfs->device->runtime_pm

There are also obvious hackish ways to handle it like passing a 0
length read to indicate close etc - they save memory but they are
asking for problems in future.

