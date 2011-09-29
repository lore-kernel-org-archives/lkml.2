Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1I2OYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:24:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab1I2OYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:24:47 -0400
Subject: Re: [PATCH v3 19/24] C6X: headers
From: Mark Salter <msalter@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Thu, 29 Sep 2011 10:24:43 -0400
In-Reply-To: <201109281607.11228.arnd@arndb.de>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com>
	 <1317155405-26235-20-git-send-email-msalter@redhat.com>
	 <201109281607.11228.arnd@arndb.de>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1317306284.2580.119.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 16:07 +0200, Arnd Bergmann wrote:
> On Tuesday 27 September 2011, Mark Salter wrote:
> > diff --git a/arch/c6x/include/asm/unaligned.h b/arch/c6x/include/asm/unaligned.h
> > new file mode 100644
> > index 0000000..1dcb006
> > --- /dev/null
> > +++ b/arch/c6x/include/asm/unaligned.h
> > @@ -0,0 +1,288 @@
> > +/*
> > + *  Port on Texas Instruments TMS320C6x architecture
> 
> This file basically just optimizes unaligned endianess conversion, but
> you don't provide an optimized swab.h, which is the regular endianess
> conversion.
> 
> I think it would less code and more useful to provide your own swab.h
> and use the generic unaligned.h.
> 

Ah, I missed swab.h which is a trivial optimization. We can do 1 cycle
swab16, 2 cycle swab32, and 3 cycle swab64.

I think we still want the c6x unaligned.h because the hardware can do
unaligned 32 and 64 memory accesses with no performance penalty. There
are some addressing mode limitations which is why the compiler doesn't
use them generally.

--Mark


