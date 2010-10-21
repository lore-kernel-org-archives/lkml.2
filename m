Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab0JUQ0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 12:26:01 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56687 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab0JUQ0A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 12:26:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eFLQK17mLxpJYA1YOU3Hk5SP2P5amoKPlmheRWIk+H4zF+5nNPl5eEUjRHptpu3awP
         yZMERCl4WMV7cYTHN846o4+n7pQS1kQ3GOw5quVq2/fm7tk/crtkKPXerQy/6NpakgN8
         uif6aUJJeeKgB8+8jPXc7KToXn43ZD7UtvuYg=
MIME-Version: 1.0
In-Reply-To: <20101021125809.GA15031@linux-mips.org>
References: <74b5d3ba9506b2e6d885546bd6dcdaec@localhost>
	<20101021125809.GA15031@linux-mips.org>
Date: Thu, 21 Oct 2010 09:25:59 -0700
Message-ID: <AANLkTinJ4wU30AaBhcvJRLZ_iw-eo9tEkds8QA1S=Nqw@mail.gmail.com>
Subject: Re: [PATCH v2 8/9] MIPS: Honor L2 bypass bit
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 5:58 AM, Ralf Baechle <ralf@linux-mips.org> wrote:
> I did a bit of research in the meantime.  Turns out that some MIPS
> customers are using their own L2 cache controller.  That means a simple
> check by the CPU PrID is not sufficient and we will need some sort of
> platform-specific probe, sigh.

FWIW, I did check the software user's manual for each of the four
processors in the list and verified that L2B is at CONFIG2 bit 12.  It
would be very rude for an L2 designer to redefine those bits in
defiance of the SUM, no?

I also rechecked 24KE just now, and found that L2B is defined in the
latest rev of the SUM, but in my local copy (Revision 01.02) bit 12 is
the MSB of SS instead.  Hmmm.
