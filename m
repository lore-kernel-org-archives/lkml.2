Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab2D0Ryf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:54:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39024 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760502Ab2D0Ryd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:54:33 -0400
Message-ID: <4F9ADD22.70003@zytor.com>
Date: Fri, 27 Apr 2012 10:53:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Arnd Bergmann <arnd@arndb.de>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 1/2] asm-generic: io: remove {read,write} string functions
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com> <4F9AC806.60608@zytor.com> <20120427171433.GE14743@mudshark.cambridge.arm.com>
In-Reply-To: <20120427171433.GE14743@mudshark.cambridge.arm.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 10:14 AM, Will Deacon wrote:
> 
> If you remove the architecture-specific drivers, there's really not a lot left
> and, even then, we only need to convert those drivers which are intended to
> be portable between architectures where the string functions are not
> consistently available.
> 
> By overheads, I assume you're referring to the IO_COND check on the address
> space? I wouldn't expect this to be noticeable compared to the cost of the
> I/O access and I'm not sure it's worth worrying about for the sake of the
> small number of drivers affected.
> 

It's not in time, but it adds bulk to the code.  The point is that what
is the benefit of not making these part of the general API?  For
architectures where the address space doesn't matter they could just
alias it to the same functions, or use the generic versions.

	-hpa


