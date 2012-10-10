Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab2JJTx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 15:53:57 -0400
Received: from mail.x86-64.org ([217.9.48.20]:45802 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab2JJTx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 15:53:56 -0400
Date: Wed, 10 Oct 2012 21:53:54 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "jejb@parisc-linux.org" <jejb@parisc-linux.org>,
        "deller@gmx.de" <deller@gmx.de>
Subject: Re: [RFC PATCH 0/3] mca_config stuff
Message-ID: <20121010195354.GA5681@aftab.osrc.amd.com>
References: <1349878801-15956-1-git-send-email-bp@amd64.org>
 <3908561D78D1C84285E8C5FCA982C28F19D49FA8@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D49FA8@ORSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 03:35:56PM +0000, Luck, Tony wrote:
> > Therefore, I can toggle the bits in the mce code with mca_cfg.<bitname>.
> > When defining accessing them through the device attributes in sysfs, I
> > use a new macro DEVICE_BIT_ATTR which gets the corresponding bit number
> > of that same bit in the bitfield. This gives only one function which
> > operates on a bitfield instead of a single function per bit in the
> > bitfield.
> 
> Is this true across all architectures? I know that pa-risc instructions
> that operate on bitfields use "0" to operate on the high order bit
> rather than the low order one. I don't recall whether this spills over
> into the compiler. If it did, then you'd have to have different #defines
> for the bit numbers[1].  For this specific use case it wouldn't matter because
> you are just using it in x86 code. But device_store_bit() and device_show_bit()
> are in generic code - so they must be able to work across all architectures.
> 
> -Tony
> 
> [1] Or fix the store/show bit functions to transform the bit numbers from
> "little-bitian" to "big-bitian" on architectures that count the other way.

Ok, the question is whether those device_{show,store}_bit functions
should be really made available in generic code. If yes, then the store case
could be made to work on any arch like this:

       if (val)
               *bvec |= le64_to_cpu(BIT_64(bit));
       else
               *bvec &= le64_to_cpu(~BIT_64(bit));

by keeping the bitnumbers little endian.

IMHO of course.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
