Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0KWRdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 12:33:35 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60536 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab0KWRde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 12:33:34 -0500
Date: Tue, 23 Nov 2010 17:33:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/20] ARM: LPAE: MMU setup for the 3-level page
	table format
Message-ID: <20101123173319.GA26510@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-9-git-send-email-catalin.marinas@arm.com> <20101122131010.GD31227@n2100.arm.linux.org.uk> <AANLkTikGVZ5Na0GSG5ynO+YM2M6x65yb3dwJeBZjzFMN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikGVZ5Na0GSG5ynO+YM2M6x65yb3dwJeBZjzFMN@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 11:38:15AM +0000, Catalin Marinas wrote:
> On 22 November 2010 13:10, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > Are you sure these shifts by 18 places are correct?  They're actually
> > (val >> SECTION_SHIFT) << 2, so maybe they should be (SECTION_SHIFT -
> > PMD_WORDS) ?
> 
> SECTION_SHIFT - PMD_ORDER is (20 - 2) for classic page tables and (21
> - 3) for LPAE. But we could change the 18 to some macros for
> clarification (the line would be long though).

So yes, it's SECTION_SHIFT - PMD_ORDER, which is how they should be
used IMHO.  I don't see why another macro would be necessary.
