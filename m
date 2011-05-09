Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab1EILAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 07:00:05 -0400
Received: from service87.mimecast.com ([94.185.240.25]:55588 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751678Ab1EILAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 07:00:03 -0400
Subject: Re: [PATCH v5 02/19] ARM: LPAE: add ISBs around MMU enabling code
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <Will.Deacon@arm.com>
In-Reply-To: <20110509103242.GQ27807@n2100.arm.linux.org.uk>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
	 <1304859098-10760-3-git-send-email-catalin.marinas@arm.com>
	 <20110508214101.GO27807@n2100.arm.linux.org.uk>
	 <1304936539.7658.31.camel@e102109-lin.cambridge.arm.com>
	 <20110509103242.GQ27807@n2100.arm.linux.org.uk>
Organization: ARM Limited
Date: Mon, 09 May 2011 11:59:54 +0100
Message-ID: <1304938794.7658.56.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 09 May 2011 10:59:59.0373 (UTC) FILETIME=[3D258BD0:01CC0E38]
X-MC-Unique: 111050912000005401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 11:32 +0100, Russell King - ARM Linux wrote:
> On Mon, May 09, 2011 at 11:22:19AM +0100, Catalin Marinas wrote:
> > Alternatively an exception return would do as well (like movs pc, lr)
> > but I think we still add some code for setting up the SPSR.
> 
> That gives us a way out of both of these without introducing any CPU
> specific code.  We can setup the SPSR before this block of code, and
> call it with two movs pc, reg instructions which will provide the
> necessary synchronization.

We still need an ISB before enabling the MMU to make sure that the TTBR
changing is visible. We may run with the MMU enabled (in the identity
mapping) before the exception return but with random data in TTBR.

-- 
Catalin


