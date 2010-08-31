Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab0HaA55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 20:57:57 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36729 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab0HaA54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 20:57:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=irFxI9MWXFiwFtqKoxnHkeCBkAiAL0fC3afqpcIyfBk2h0RLB4Ddjrb8iWZPxakAGs
         O5w2mFZuMw1OSgdmDmOCcFJV9/dcVY2DnPmCaDVfJpPi1LYyhS/FK5kZ8clYYocuLGxm
         O5Ot2H6oCHC/dNInDmfYwxjcDSkLw0lHm/nI8=
Subject: Re: [Question] How to test (DRAM) memory location.
From: Calvin Walton <calvin.walton@gmail.com>
To: santosh <santosh.iitg@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinYuck4yEGpFDKZp-R3N2dtoQ68cLHQY6EW6sr-@mail.gmail.com>
References: <AANLkTinYuck4yEGpFDKZp-R3N2dtoQ68cLHQY6EW6sr-@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 20:57:49 -0400
Message-ID: <1283216269.3738.6.camel@ayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-28 at 16:57 +0530, santosh wrote:
> Hi,
> 
> I need to write a memory diagnosis  program which will test each and
> every location of SDRAM
> to know whether its working properly or a bad location
> 
> What would be the best approach ??

If you can, it's best to just use code other people have already
written :)

If you can reboot the computer to test the memory, Memtest86+ is a
well-known and very reliable tool which does just what you ask. You can
obtain it from http://www.memtest.org/

There's some work done on an in-kernel memory tester, but testing memory
while Linux is running is somewhat limited as there are sections of
memory that you can't overwrite during testing. Take a look at
CONFIG_MEMTEST and arch/x86/mm/memtest.c (which is currently only
capable of testing memory in early boot).

-- 
Calvin Walton <calvin.walton@gmail.com>

