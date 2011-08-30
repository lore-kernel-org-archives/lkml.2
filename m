Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab1H3VPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 17:15:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57558 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756672Ab1H3VPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 17:15:35 -0400
Date: Tue, 30 Aug 2011 22:15:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 3/4] platform: (TS-5500) add LED support
Message-ID: <20110830211528.GU2061@opensource.wolfsonmicro.com>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1314402027-11293-4-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20110829221654.GD26846@sirena.org.uk>
 <4E5C7731.3080309@zytor.com>
 <20110830171424.71465472@v0nbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110830171424.71465472@v0nbox>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 05:14:24PM -0400, Vivien Didelot wrote:
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> > On 08/29/2011 03:16 PM, Mark Brown wrote:

> > > Can you not do outb() from atomic context?  The reason lots of LED
> > > drivers update the hardware in a workqueue is that they communicate
> > > with the hardware over buses that can't be used in atomic context
> > > like I2C or SPI but if that's not an issue then the workqueue is
> > > not required and the code can be simplified.

> > outb() can definitely be executed from atomic context.

> Good to know, thanks. I removed the work_struct and instead lock a mutex
> before setting led->new_brightness and calling outb().

You can't take a mutex in atomic context...
