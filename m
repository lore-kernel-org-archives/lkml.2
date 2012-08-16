Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2HPMjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:39:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab2HPMjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:39:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 21/31] arm64: 32-bit (compat) applications support
Date: Thu, 16 Aug 2012 12:39:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <201208151434.05145.arnd@arndb.de> <20120816102808.GH31784@mudshark.cambridge.arm.com>
In-Reply-To: <20120816102808.GH31784@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208161239.31409.arnd@arndb.de>
X-Provags-ID: V02:K0:vzZmdiAkDRw0zrQ1YkCDHLIeQNpNPEbzmV9CRRvEz+2
 +7F9EQ1ZXBtoPivQPwmmPiaO3mdgxLMgi0TFzykg5xowgZyeCh
 74LBTr3lwqdwCWdCXsrnHwl6b9rADB2ORhNME23UTEhtP7Xtef
 NuDQrocAYuOIs9dN+XlRzL5N38I+ZREXkj8ZmI8F0PEHf4uot3
 bOi0nzTcAHoXVxe72MkLT8vqmoZDRHMkw1FUBZocv4HWwrOVd/
 mBthkhQv9JHYVGVPjUpR3aOEDvVPsoebbkDSuIXuPcaUdfTsRX
 IGQ4IewwqiBnCDlnAiFXKCT8dUKWm+mXZg1mdD+4a+ODVR7/zp
 hUTZ5Bnhuyq34unAGxpA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2012, Will Deacon wrote:
> 
> On Wed, Aug 15, 2012 at 03:34:04PM +0100, Arnd Bergmann wrote:
> > On Tuesday 14 August 2012, Catalin Marinas wrote:
> > > +asmlinkage int compat_sys_personality(compat_ulong_t personality)
> > > +{
> > > +   int ret;
> > > +
> > > +   if (personality(current->personality) == PER_LINUX32 &&
> > > +           personality == PER_LINUX)
> > > +           personality = PER_LINUX32;
> > > +   ret = sys_personality(personality);
> > > +   if (ret == PER_LINUX32)
> > > +           ret = PER_LINUX;
> > > +   return ret;
> > > +}
> > 
> > Where did you get this from?
> > 
> > You should not need compat_sys_personality, just call the native function.
> 
> Hmm, but in that case an aarch32 application doing a personality(PER_LINUX)
> syscall will start seeing the wrong uname.

Not the wrong uname, just the default one, which is correct.

	Arnd
