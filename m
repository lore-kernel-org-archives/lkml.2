Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab0JVAZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:25:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50372 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab0JVAZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:25:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hjQEyh3PbI5y4fqDtqnlETgywNOBXukKVd4X7jRq/OBIX1PUQ18Q3yGKkGJAHS5q+t
         N3hPMdFag7vXSCakWnAuWMSwAYCd+kElohhrnJNK2/IsVV0Bh2Ckfu1zGUG7guFVGUi/
         UwBRH/hyXHamrlCMrnaf5OwaoOvIeBNWkZhVk=
Subject: Re: [PATCH] sdio: fix suspend/resume regression
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-mmc@vger.kernel.org,
        Sven Neumann <s.neumann@raumfeld.com>, Chris Ball <cjb@laptop.org>,
        libertas-dev@lists.infradead.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Mack <daniel@caiaq.de>, Colin Cross <ccross@android.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, stable@kernel.org
In-Reply-To: <alpine.LFD.2.00.1010211952110.2764@xanadu.home>
References: <1286788315.3101.11.camel@sven>
	 <1286955116-22793-1-git-send-email-ohad@wizery.com>
	 <1287704855.12734.14.camel@maxim-laptop>
	 <alpine.LFD.2.00.1010211952110.2764@xanadu.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 02:25:11 +0200
Message-ID: <1287707111.12734.30.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 19:55 -0400, Nicolas Pitre wrote:
> On Fri, 22 Oct 2010, Maxim Levitsky wrote:
> 
> > So what happens if you set .suspend to NULL? instead of -ENOSYS return?
> 
> At run time, the driver may decide to handle the suspend request and 
> return 0, or decide to simply return -ENOSYS if it doesn't want to 
> bother with the suspend meaning that the card should be removed, or 
> return another error code meaning that the suspend request must be 
> aborted.

I am afraid that this is very hard to support.
If .suspend would be called from pm notifier, it would create problems
last time I checked.
Or maybe it won't?
I will test that again, as it might be very nice solution.
I could even just call the mmc_suspend_host from the pm notifier.

Best regards,
	Maxim Levitsky

