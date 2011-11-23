Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab1KWOAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:00:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54823 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab1KWOAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:00:34 -0500
MIME-Version: 1.0
In-Reply-To: <20111123061355.GA3295@mwanda>
References: <5C0D372F-F03E-4EB8-8440-83A8D1C95363@gmail.com> <20111123061355.GA3295@mwanda>
From: Xi Wang <xi.wang@gmail.com>
Date: Wed, 23 Nov 2011 08:59:52 -0500
Message-ID: <CAKU6vyZdC64piK-mn6kLMt1-RhhM8D-4KbAGxje087FJ9X=fNA@mail.gmail.com>
Subject: Re: [PATCH] comedi: integer overflow in do_insnlist_ioctl()
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Mori Hess <fmhess@users.sourceforge.net>, security@kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ian Abbott <abbotti@mev.co.uk>,
        Franky Lin <frankyl@broadcom.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        Mark Pearson <markpearson_de@yahoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the pointer.  However you cannot do the overflow check using

  if (sizeof(struct comedi_insn) * insnlist.n_insns < insnlist.n_insns)

Let's assume 32-bit system, sizeof(struct comedi_insn) = 32, and
insnlist.n_insns = 0x7fffffff.

Note that 32 * 0x7fffffff = 0xffffffe0 overflows but bypasses your check.

- xi

On Wed, Nov 23, 2011 at 1:13 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> I sent a patch for this already.
>
> http://driverdev.linuxdriverproject.org/pipermail/devel/2011-November/022469.html
>
> regards,
> dan carpenter
>
>
>
