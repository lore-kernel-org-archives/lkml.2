Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab1BQOlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:41:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51990 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab1BQOlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 09:41:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: John Linn <John.Linn@xilinx.com>
Subject: Re: [PATCH V3 3/4] ARM: Xilinx: base header files and assembly macros
Date: Thu, 17 Feb 2011 15:41:11 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Jamie Iles <jamie@jamieiles.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        catalin.marinas@arm.com, glikely@secretlab.ca
References: <1297872716-13353-1-git-send-email-john.linn@xilinx.com> <20110217100126.GD22961@pulham.picochip.com> <71326bcb-7836-4820-84c1-f3d8257e9f92@VA3EHSMHS020.ehs.local>
In-Reply-To: <71326bcb-7836-4820-84c1-f3d8257e9f92@VA3EHSMHS020.ehs.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171541.12261.arnd@arndb.de>
X-Provags-ID: V02:K0:Ug5TvCzds4n0LH5hTngN0CrIQVepQdDQJGwf7kIBiWy
 x5ZOB3qiOWpQVwtlS18RlB9bPvkJIvdQ2yPM2bD/xzQmC+kmXo
 qS9Tz19V/PEHQ7Za5MpjpV4V8ey14QQuGT2M3+MrMtxrdT54ry
 D46fGb2oalwV0vodjwT1hotYYUJh0n0K3GZUJyLTfMB4/WWXl1
 YQ5k0wRO4gorQV/alLPRw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 February 2011, John Linn wrote:
> > > +
> > > +#define UART_FIFO_WRITE(base, value) \
> > > +   (*(volatile unsigned int *)((base) + UART_FIFO_OFFSET) =
> (value))
> > > +
> > > +#define UART_STATUS(base) \
> > > +   (*(volatile unsigned int *)((base) + UART_SR_OFFSET))
> > 
> > You could probably make these static inline functions in the header
> and
> > use __raw_{readl,writel}() to make this a little cleaner.
> > 
> 
> I had considered that, but it wasn't clear to me at the time what the
> compressor could use or not.
> 
> I'll give it a try as I agree that's cleaner.

Actually, for correctness you should use the regular readl/writel, not
the __raw_ versions, which can result in reordered or partial accesses
on the bus.

	Arnd
