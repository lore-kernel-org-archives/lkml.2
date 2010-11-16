Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142Ab0KPJ7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 04:59:54 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55976 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783Ab0KPJ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 04:59:53 -0500
Date: Tue, 16 Nov 2010 09:59:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/20] ARM: LPAE: Factor out 2-level page table
	definitions into separate files
Message-ID: <20101116095938.GA12891@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-3-git-send-email-catalin.marinas@arm.com> <20101115233129.GG31421@n2100.arm.linux.org.uk> <AANLkTikrz+yM6idm-aij10vsKZMVSOBfZSdeEJbDRwiC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikrz+yM6idm-aij10vsKZMVSOBfZSdeEJbDRwiC@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 09:14:52AM +0000, Catalin Marinas wrote:
> On 15 November 2010 23:31, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > This should become:
> >
> > typedef struct { pteval_t pte; } pte_t;
> >
> > L_PTE_* can then be declared using linux/const.h stuff to typedef them
> > to pteval_t.
> 
> I already do this for LPAE but can be done for the 2-level definitions
> for consistency.

No you don't.  You define the 2nd level definitions using pmd_t which
is _wrong_.  pmd_t is the type of the pmd container, not the pmd value.

> BTW, do you think it's worth adding STRICT_MM_TYPECHECKS for LPAE as
> well? It would probably spot some issues.

Definitely, because it'll throw out warnings for most of your _AT(pmd_t,)
definitions.
