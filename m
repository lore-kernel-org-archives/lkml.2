Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123Ab1GUUke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 16:40:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52394 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1GUUkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 16:40:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Shawn Guo <shawn.guo@freescale.com>,
        ashishj3 <ashish.jangam@kpitcummins.com>,
        Dajun <dajun.chen@diasemi.com>, sameo@openedhand.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] MFD: DA9052 MFD core module v2
Date: Thu, 21 Jul 2011 22:40:23 +0200
Message-ID: <11313494.PB6mQOoBLX@wuerfel>
User-Agent: KMail/4.6.0 (Linux/3.0.0-rc1nosema+; KDE/4.6.90; x86_64; ; )
In-Reply-To: <20110721154748.GB23192@opensource.wolfsonmicro.com>
References: <1309876620.960.169.camel@L-0532.kpit.com> <20110721154631.GA26837@S2100-06.ap.freescale.net> <20110721154748.GB23192@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:323utes/d1Wlq0l3cSQqobR0VjAgx2yyF8mYU7DWAFz
 k4ergISEJ3GO3Lzk1Zfn4e6B4WRo6QC4qqWXsvV+u4R9xXniK8
 ysi0PkiHPWg8sjjNX/oj/mCzdlQczDiuBGe2uQ2yoYR9iipngC
 2HWiCE5/C9VN5T6FGxyxk3j9TjYRXJRRdoNB0qf1T9qpDtv78W
 QOWE+nJ1a+BuEUtt1klyw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 July 2011 16:47:48 Mark Brown wrote:
> On Thu, Jul 21, 2011 at 11:46:32PM +0800, Shawn Guo wrote:
> > On Tue, Jul 05, 2011 at 08:07:00PM +0530, ashishj3 wrote:
> 
> > > +   mutex_lock_interruptible(&da9052->io_lock);
> 
> > Compile warning as below.
> 
> > "warning: ignoring return value of ‘mutex_lock_interruptible’,
> > declared with attribute warn_unused_result"
> 
> Although the bigger problem is why are these interruptible?  That's
> very unusual.

Well, the default should really be to use _interruptible or at least
_killable with the appropriate error handling, and only use noninterruptible
locks  in cases where that's not possible.

In the funtions that Shawn pointed out, there is an error return, so it would
be possible to do that, but the callers would need to be audited carefully.

	Arnd
