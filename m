Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1BBRKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 12:10:24 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58209 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab1BBRKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 12:10:22 -0500
Date: Wed, 2 Feb 2011 17:09:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Richard Guenther <richard.guenther@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Peter Maydell <peter.maydell@linaro.org>,
        gcc@gcc.gnu.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: ARM unaligned MMIO access with attribute((packed))
Message-ID: <20110202170959.GA31043@n2100.arm.linux.org.uk>
References: <201102021700.20683.arnd@arndb.de> <AANLkTin6qEeN7XZuwePNWqS8i_aDY586V+sOqgD5pPQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin6qEeN7XZuwePNWqS8i_aDY586V+sOqgD5pPQA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 05:51:27PM +0100, Richard Guenther wrote:
> > I would suggest fixing this by:
> >
> > 1. auditing all uses of __attribute__((packed)) in the Linux USB code
> > and other drivers, removing the ones that are potentially harmful.
> >
> > 2. Changing the ARM MMIO functions to use inline assembly instead of
> > direct pointer dereference.
> >
> > 3. Documenting the gcc behavior as undefined.
> 
> The pointer conversions already invoke undefined behavior as specified by the
> C standard (6.3.2.3/7).

Just to be clear: you are not saying that the ARM implementation is
undefined.

What you're saying is that converting from a pointer with less strict
alignment requirements to a pointer with more strict alignment
requirements is undefined.

IOW:

unsigned long *blah(unsigned char *c)
{
	return (unsigned long *)c;
}

would be undefined, but:

unsigned char *blah(unsigned long *c)
{
	return (unsigned char *)c;
}

would not be.

If you're saying something else, please explain with reference to the
point in the C standard you quote above.
