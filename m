Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab0KWRfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 12:35:36 -0500
Received: from service87.mimecast.com ([94.185.240.25]:46612 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755179Ab0KWRff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 12:35:35 -0500
Subject: Re: [PATCH v2 08/20] ARM: LPAE: MMU setup for the 3-level page
 table format
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101123173319.GA26510@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	 <1289584840-18097-9-git-send-email-catalin.marinas@arm.com>
	 <20101122131010.GD31227@n2100.arm.linux.org.uk>
	 <AANLkTikGVZ5Na0GSG5ynO+YM2M6x65yb3dwJeBZjzFMN@mail.gmail.com>
	 <20101123173319.GA26510@n2100.arm.linux.org.uk>
Organization: ARM Limited
Date: Tue, 23 Nov 2010 17:35:29 +0000
Message-ID: <1290533729.6381.128.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 23 Nov 2010 17:35:29.0649 (UTC) FILETIME=[D2820E10:01CB8B34]
X-MC-Unique: 110112317353201001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 17:33 +0000, Russell King - ARM Linux wrote:
> On Tue, Nov 23, 2010 at 11:38:15AM +0000, Catalin Marinas wrote:
> > On 22 November 2010 13:10, Russell King - ARM Linux
> > <linux@arm.linux.org.uk> wrote:
> > > Are you sure these shifts by 18 places are correct?  They're actually
> > > (val >> SECTION_SHIFT) << 2, so maybe they should be (SECTION_SHIFT -
> > > PMD_WORDS) ?
> >
> > SECTION_SHIFT - PMD_ORDER is (20 - 2) for classic page tables and (21
> > - 3) for LPAE. But we could change the 18 to some macros for
> > clarification (the line would be long though).
> 
> So yes, it's SECTION_SHIFT - PMD_ORDER, which is how they should be
> used IMHO.  I don't see why another macro would be necessary.

I didn't mean adding another macro but using (SECTION_SHIFT - PMD_ORDER)
on a long line.

-- 
Catalin


