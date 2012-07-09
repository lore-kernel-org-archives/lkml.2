Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab2GIQCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 12:02:34 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51926 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306Ab2GIQCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 12:02:32 -0400
Date: Mon, 9 Jul 2012 17:02:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120709160212.GD15120@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20120709113558.GE8052@arm.com>
 <20120709145126.313d1574@pyramind.ukuu.org.uk>
 <201207091532.12256.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207091532.12256.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Mon, Jul 09, 2012 at 04:32:11PM +0100, Arnd Bergmann wrote:
> We have a lot of reviewers that are familiar with the 32 bit code, so
> I think the main strategy should be to spot duplicate code early
> and make sure we deal with it individually. Examples for this are
> probably the implementations for kvm and perf, which largely deal
> with the same hardware on both architectures. Those definitely must
> not get duplicated into mostly-identical files. In many cases, we're
> moving those things into drivers/*, in other cases we might want to
> use Makefile logic to include a sub-directory from one arch into another,
> as we do for arch/um.

I don't see why we would need to get a subdir from one into the other.
If the SoCs would need some common drivers (like GPIO), they should go
into drivers/ anyway. There is some perf code that could be shared
(though not building a subdir as we have different instruction sets) but
I would like that moved to a more generic place.

-- 
Catalin
