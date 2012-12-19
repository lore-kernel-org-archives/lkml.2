Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2LSXa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:30:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53386 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab2LSXaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:30:17 -0500
Date: Thu, 20 Dec 2012 00:30:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
Message-ID: <20121219233014.GN24895@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
	Yinghai Lu <yinghai@kernel.org>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	"Yu, Fenghua" <fenghua.yu@intel.com>,
	"mingo@kernel.org" <mingo@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"linux-tip-commits@vger.kernel.org" <linux-tip-commits@vger.kernel.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
References: <CAE9FiQUPeK-WB163KViPPLYFgw5pUq6Rk=CvvOrWQEfjS=FBEQ@mail.gmail.com>
 <50CCF6F6.4020107@zytor.com>
 <CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com>
 <50CD04F1.8020902@zytor.com>
 <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com>
 <20121219220504.GA32212@jshin-Toonie>
 <50D23EE8.7030904@zytor.com>
 <20121219225505.GA2968@jshin-Toonie>
 <20121219230015.GL24895@liondog.tnic>
 <50D24B27.5080705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50D24B27.5080705@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 03:17:59PM -0800, H. Peter Anvin wrote:
> I presume with "too big" he really means "oddly shaped".

Yeah, that's why it could be enlarged a little in order to adjust it to
the MTRR scheme. This is what the BKDG says about it:

PhysMask and PhysBase are used together to determine whether a target
physical-address falls within the specified address range. PhysMask
is logically ANDed with PhysBase and separately ANDed with the upper
40 bits of the target physical-address. If the results of the two
operations are identical, the target physical-address falls within the
specified memory range. The pseudo-code for the operation is:

MaskBase = PhysMask AND PhysBase
MaskTarget = PhysMask AND Target_Address[51:12]
IF MaskBase == MaskTarget
    target address is in range
ELSE
    target address is not in range

And then there are the alignment requirements:

* The boundary on which a variable range is aligned must be equal to the
range size. For example, a memory range of 16 Mbytes must be aligned on
a 16-Mbyte boundary.

* The range size must be a power of 2 (2n, 52 > n > 11), with a minimum
allowable size of 4 Kbytes. For example, 4 Mbytes and 8 Mbytes are
allowable memory range sizes, but 6 Mbytes is not allowable.

and then some examples about how to calculate those values.

Jacob, if you still have the system, you might try to experiment with
that, provided there are some variable MTRRs free, of course. And also
provided, there's nothing else in the hw stopping us from doing that.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
