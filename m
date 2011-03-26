Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab1CZNlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 09:41:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51409 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1CZNlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 09:41:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eZHNIzkj3DoVxueP56JAkxMPpa3fNzwz/CRGIRCTLX/RNM26Y4G8E/X4VPTjs+waYL
         /+Vlh3YAVl7jpmUYLHUHD0pZ58D5Bt7ofYjVyo+OEPJxDWipTchcIS66+9nTo8Ag8F58
         1mcUgjsYYg63N9myQcJE4+B+e9fkk1+mQr40I=
Date: Sat, 26 Mar 2011 14:40:59 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH V12 4/4] ptp: Added a clock driver for the National
 Semiconductor PHYTER.
Message-ID: <20110326134059.GC23260@riccoc20.at.omicron.at>
References: <cover.1298878618.git.richard.cochran@omicron.at>
 <f8af215ebe32a8c0f4b3a82b8ee7e8008b4feb1e.1298878618.git.richard.cochran@omicron.at>
 <1300916785.848.54.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300916785.848.54.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 02:46:25PM -0700, John Stultz wrote:
> On Mon, 2011-02-28 at 08:58 +0100, Richard Cochran wrote:
> > +static int tdr_write(int bc, struct phy_device *dev,
> > +		     const struct timespec *ts, u16 cmd)
> > +{
> > +	ext_write(bc, dev, PAGE4, PTP_TDR, ts->tv_nsec & 0xffff);/* ns[15:0]  */
> > +	ext_write(bc, dev, PAGE4, PTP_TDR, ts->tv_nsec >> 16);   /* ns[31:16] */
> > +	ext_write(bc, dev, PAGE4, PTP_TDR, ts->tv_sec & 0xffff); /* sec[15:0] */
> > +	ext_write(bc, dev, PAGE4, PTP_TDR, ts->tv_sec >> 16);    /* sec[31:16]*/
> > +
> > +	ext_write(bc, dev, PAGE4, PTP_CTL, cmd);
> > +
> > +	return 0;
> > +}
> 
> The above needs to hold the extreg_lock, and should be commented as
> such.

Okay, will do.

> And again, the function names are sort of generic, and could use a
> dp83640_ prefix or something.

So, I will rename the IXP functions in the other driver to make them
more unique, but in this case I really prefer to keep the short names
for the sake of readability.

Just about every operation on this PHY requires four 16-bit writes,
where each write can really mean two writes, with the first one to set
a "page" register for the following write.

Keeping the tabular style (shown above) makes it much more clear what
is going on, IMHO. If the function names become longer, that would
force line breaks and spoil the nice formatting.

Also, these names are not in use anywhere else in the kernel's eight
million LOC.

Thanks,

Richard
