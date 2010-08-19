Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab0HSJWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 05:22:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45432 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0HSJW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 05:22:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FKU8KA0QDL9WufuThhBSnZ7aJwhPbBx/e8z8GJCy3eJ9si0YwHX3PRA7bkNpQgFjiQ
         64e2NtsStTZHV0/teK+P4fl8DjAacjcq7j3j79XXHLStSIsQduyg/zwaL4EBMNmMDU6V
         88pW7/X1Gk+0pvTyXfh7rHtaVJQJBiNS9GekI=
Date: Thu, 19 Aug 2010 11:22:47 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: john stultz <johnstul@us.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        Rodolfo Giometti <giometti@linux.it>, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
Message-ID: <20100819092246.GA8484@riccoc20.at.omicron.at>
References: <cover.1281956490.git.richard.cochran@omicron.at>
 <201008171336.29375.arnd@arndb.de>
 <20100818140440.GA22655@riccoc20.at.omicron.at>
 <201008181702.03384.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008181702.03384.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 05:02:03PM +0200, Arnd Bergmann wrote:
> You might want to use callbacks for these system calls that you
> can register to at module load time, like it is done for the
> existing syscalls.

Can you point me to a specific example?

> The simpler way (e.g. for testing) is using Kconfig dependencies, like
> 
> config PTP
> 	bool "IEEE 1588 Precision Time Protocol"
> 
> config PPS
> 	tristate "Pulse per Second"
> 	depends on PTP || !PTP
> 
> The depends statement is a way of expressing that when PTP is enabled,
> PPS cannot be a module, while it may be a module if PTP is disabled.

THis did not work for me.

What I got was, in effect, two independent booleans.


Thanks,

Richard
