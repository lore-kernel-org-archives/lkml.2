Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab1BCAZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:25:01 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:35831 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755180Ab1BCAY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:24:59 -0500
Date: Wed, 2 Feb 2011 16:24:59 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: Early crash (was: Re: module: show version information for
 built-in modules in sysfs)
Message-ID: <20110203002459.GA26729@dtor-ws.eng.vmware.com>
References: <AANLkTin4gOnEMruLDM=TkNYsNf5S370WqbcDVJzT7_Z4@mail.gmail.com>
 <20110201210944.GA12348@dtor-ws.eng.vmware.com>
 <AANLkTimv=KqtuR36dMNa+=OMi0mgd8JK4qsb_SpmKmhs@mail.gmail.com>
 <20110201222637.GA17521@dtor-ws.eng.vmware.com>
 <AANLkTikWVt8NEyHN+=yD4EWSXUQt0gt5nLJtKQDw397M@mail.gmail.com>
 <20110202194227.GA13794@dtor-ws.eng.vmware.com>
 <m2ipx2dp7v.fsf@igel.home>
 <20110202235948.GA8676@dtor-ws.eng.vmware.com>
 <m2bp2udllv.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2bp2udllv.fsf@igel.home>
Thread-Topic: Early crash (was: Re: module: show version information for
 built-in modules in sysfs)
Accept-Language: en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 04:10:04PM -0800, Andreas Schwab wrote:
> Dmitry Torokhov <dtor@vmware.com> writes:
> 
> > Even pointers? I'd expect pointers to be aligned on 4-bytes boundaries?
> 
> Pointers are not special in any way.  Why should they?  On the machine
> level pointers are just numbers.

Are pointers (along with ints/longs) on m68k naturally aligned on word
boundary even though they are 32 bit?

Anyway, here is the description that introduced alignment statement:

commit 02dba5c6439cff34936460b95cd1ba42b370f345
Author: ak <ak>
Date:   Sat Jun 21 16:18:16 2003 +0000

    [PATCH] Fix over-alignment problem on x86-64

    Thanks to Jan Hubicka who suggested this fix.

    The problem seems to be that gcc generates a 32byte alignment for static
    objects > 32bytes.  This causes gas to set a high alignment on the
    section, which causes the uneven (not multiple of sizeof(struct
    kernel_param)) section size.  The pointer division with a base not being
    a multiple of sizeof(*ptr) then causes the invalid result.

    This just forces a small alignment, which makes the section end come out
    with the correct alignment.

    The only mystery left is why ld chose a 16 byte padding instead of
    32byte.

    BKrev: 3ef485487jZN-h3PtASDeL2Vs55NIg


I guess this does not directly apply to modversions since they are
currently under 32 bytes, but I wonder what happen if we decide to
extend one of the structures involved...

I guess explicitly setting alignment requirement for struct
module_version_attribute is the best option.

Thanks,
Dmitry


