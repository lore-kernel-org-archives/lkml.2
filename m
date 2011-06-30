Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab1F3IeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:34:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61815 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab1F3IeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:34:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110629212420.GA9822@infradead.org>
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
	<20110629142106.447393a5.rdunlap@xenotime.net>
	<20110629212420.GA9822@infradead.org>
Date: Thu, 30 Jun 2011 16:34:07 +0800
Message-ID: <BANLkTimH49VTSqBsUiXXcb7cFE8LKgabAg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.0-rc5 (xfs on cris)
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>, xfs-masters@oss.sgi.com,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-cris-kernel@axis.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 5:24 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Jun 29, 2011 at 02:21:06PM -0700, Randy Dunlap wrote:
>> Looks like arch/cris does not support atomic64_t.  (?)
>>
>> Should we prevent xfs from being built on arch/cris?
>
> Or nuke cris until it's able to at least include an asm-generic header?
>

Not that simple. Take a look at lib/atomic64_test.c, it said:

#if defined(CONFIG_X86) || defined(CONFIG_MIPS) || defined(CONFIG_PPC) || \
    defined(CONFIG_S390) || defined(_ASM_GENERIC_ATOMIC64_H) ||
defined(CONFIG_ARM)
...
#else
#warning Please implement atomic64_dec_if_positive for your
architecture, and add it to the IF above
#endif

So cris at least needs to implement atomic64_dec_if_positive()...
