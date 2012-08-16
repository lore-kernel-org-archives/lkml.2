Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2HPK2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:28:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44096 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854Ab2HPK2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:28:15 -0400
Date: Thu, 16 Aug 2012 11:28:09 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 21/31] arm64: 32-bit (compat) applications support
Message-ID: <20120816102808.GH31784@mudshark.cambridge.arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-22-git-send-email-catalin.marinas@arm.com>
 <201208151434.05145.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151434.05145.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 03:34:04PM +0100, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, Catalin Marinas wrote:
> > +asmlinkage int compat_sys_personality(compat_ulong_t personality)
> > +{
> > +	int ret;
> > +
> > +	if (personality(current->personality) == PER_LINUX32 &&
> > +		personality == PER_LINUX)
> > +		personality = PER_LINUX32;
> > +	ret = sys_personality(personality);
> > +	if (ret == PER_LINUX32)
> > +		ret = PER_LINUX;
> > +	return ret;
> > +}
> 
> Where did you get this from?
> 
> You should not need compat_sys_personality, just call the native function.

Hmm, but in that case an aarch32 application doing a personality(PER_LINUX)
syscall will start seeing the wrong uname.

Will
