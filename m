Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab0KARxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 13:53:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:44973 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662Ab0KARxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 13:53:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,275,1286175600"; 
   d="scan'208";a="343147752"
Date: Mon, 1 Nov 2010 16:57:01 +0000
From: Alan Cox <alan@linux.intel.com>
To: samu.p.onkalo@nokia.com
Cc: ext Greg KH <gregkh@suse.de>,
        ext Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sysfs and power management
Message-ID: <20101101165701.2fc30368@linux.intel.com>
In-Reply-To: <1288608087.26073.6.camel@4fid08082>
References: <1288177143.12206.22.camel@4fid08082>
	<20101027124816.7087436a@linux.intel.com>
	<62697B07E9803846BC582181BD6FB6B836EB2994F4@NOK-EUMSG-02.mgdnok.nokia.com>
	<20101027152809.39701917@lxorguk.ukuu.org.uk>
	<20101029195039.GA26401@suse.de>
	<20101030140047.GA24464@khazad-dum.debian.net>
	<1288526275.2313.14.camel@noppispoppis.nmp.nokia.com>
	<20101031142539.GA25480@suse.de>
	<1288608087.26073.6.camel@4fid08082>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I took a look to that. It seems that iio is more or less sysfs based.
> There are ring buffers and event device which are chardev based
> but still the data outside ring buffer and the control is sysfs based.

IIO is sysfs dependant, heavyweight and makes no sense for some of the
sysfs based drivers. IIO is also staging based and Linus already threw
out the last attempt to unify these drivers sanely with an ALS layer -
which was smaller, cleaner and better !

> By getting open and close from sysfs would be nice from the driver
> point of view. However, I understand that this is just overhead for
> majority of the cases.

The alternative really is to end up with a parallel 'not quite sysfs'
which is sysfs + open/close. My feeling is its cleaner to have a hook
at the per device level (so we don't bloat the sysfs nodes at all) than
have two copies of sysfs.

Alan
