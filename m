Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0HROEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:04:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33767 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab0HROET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:04:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jmU4MjgLlBuxP3WiV9bDKU061jtTOc2OnsR8VbMrma1uMzU3IGhXIYJNnu5wKDtsM0
         JNRTcj28S/6Bwtwhclk4uR4oqUkeW6s7tHHg+ruqS1wfZsmH9l0tHCMHKE9NKInrRUa6
         V+Y2byJvMD9i456IQWwI0tRS59u3trBCOe+Ww=
Date: Wed, 18 Aug 2010 16:04:40 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: john stultz <johnstul@us.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        Rodolfo Giometti <giometti@linux.it>, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
Message-ID: <20100818140440.GA22655@riccoc20.at.omicron.at>
References: <cover.1281956490.git.richard.cochran@omicron.at>
 <201008170925.55592.arnd@arndb.de>
 <20100817105232.GA9079@riccoc20.at.omicron.at>
 <201008171336.29375.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008171336.29375.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 01:36:29PM +0200, Arnd Bergmann wrote:
> On Tuesday 17 August 2010, Richard Cochran wrote:
> > I've been looking at offering the PTP clock as a posix clock, and it
> > is not as hard as I first thought. The PTP clock or clocks just have
> > to be registered as one of the posix_clocks[MAX_CLOCKS] in
> > posix-timers.c.
> 
> Ok sounds good.

I've been working turning the PTP stuff into syscalls, but here is a
little issue I ran into. The PTP clock layer wants to call the PPS
code via pps_register_source(), but the PPS can be compiled as a
module. Since the PTP layer is now offering syscalls, it must always
be present in the kernel. So I need to make sure that the PPS is
either absent entirely or staticly linked in.

How can I do this?

Thanks,

Richard
