Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab1EWTFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:05:30 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:34231 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab1EWTFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:05:23 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Clocksource: Move the Hyper-V clocksource driver
 out of staging
Thread-Topic: [PATCH 1/1] Clocksource: Move the Hyper-V clocksource driver
 out of staging
Thread-Index: AQHMGW2o73xBkI9IxkSJtOUc7B8Bm5SbNNkA//+NI7A=
Date: Mon, 23 May 2011 19:05:22 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481FC8F8@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1306170743-17797-1-git-send-email-kys@microsoft.com>
 <20110523184233.GA26835@infradead.org>
In-Reply-To: <20110523184233.GA26835@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, May 23, 2011 2:43 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; tglx@linutronix.de; johnstul@us.ibm.com;
> hch@infradead.org; Hank Janssen; Haiyang Zhang
> Subject: Re: [PATCH 1/1] Clocksource: Move the Hyper-V clocksource driver out
> of staging
> 
> > +#include <linux/version.h>
> 
> This one shouldn't be needed.

Correct; I will fix this.
> 
> > +#include <asm/hyperv.h>
> > +#include <asm/mshyperv.h>
> 
> not really a review for this driver, but what's the purpose if having
> these two headers?

These header files have the defines for checking if we are running on 
Hyper-V.

> 
> Shouldn't the Kconfig entry also move from drivers/staging to
> arch/x86 towards the other clocksources?

Currently this driver is built if  HYPERV is defined. I agree with you
that I should have Kconfig entry in arch/x86. Since the rest of the 
Hyper-V drivers are still in staging, I am thinking that perhaps we should 
have a different config switch - HYPERV_CLKSRC. I will go ahead and 
spin a new version of this patch with this change.

Regards,

K. Y
