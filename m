Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab1EaMcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:32:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:55752 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1EaMcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:32:43 -0400
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Date: Tue, 31 May 2011 13:32:37 +0100
In-Reply-To: <20110531121215.GA4215@thunk.org>
References: <20110530104231.GF17821@elte.hu>
	 <20110530104656.GA19532@elte.hu>
	 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	 <20110530105809.GA20133@elte.hu>
	 <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	 <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
	 <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
	 <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
	 <20110531075306.GB20798@elte.hu>
	 <1306832148.2029.484.camel@i7.infradead.org>
	 <20110531121215.GA4215@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306845158.2029.543.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 08:12 -0400, Ted Ts'o wrote:
> I don't know why Ingo needs ARCH=x86 on the command line, but I
> regularly type "make ARCH=i386" when building 32-bit kernels on a
> 64-bit system, and my scripts use "make ARCH=x86_64" when building
> 64-bit kernels (just in case I happen to have booted a 32-bit
> kernel). 

Yes. That's because of the problem described in $SUBJECT.

Historically, the setting of CONFIG_64BIT in your .config file was just
completely ignored in most cases.

If you specified ARCH=i386 or ARCH=x86_64 on the command line it would
be set accordingly, but if you *didn't* set it explicitly then the build
system would *still* ignore what's in the existing .config, and just
override it to match the host!

The *only* time that the .config would be honoured was if you explicitly
added ARCH=x86 to the command line.

That's why your scripts grew these hacks, presumably.

-- 
dwmw2

