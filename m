Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab2EaHjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:39:21 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:48071 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2EaHjT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Thu, 31 May 2012 03:39:19 -0400
Message-Id: <4FC73C430200007800087137@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 31 May 2012 08:39:15 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Borislav Petkov" <bp@alien8.de>
Cc: "Andre Przywara" <andre.przywara@amd.com>,
        "Jacob Shin" <jacob.shin@amd.com>, <mingo@elte.hu>, <jeremy@goop.org>,
        <tglx@linutronix.de>, <xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
References: <4FC63DAF0200007800086DC5@nat28.tlf.novell.com>
 <4FC62888.9010407@amd.com> <20120530144851.GA12184@jshin-Toonie>
 <20120530145005.GI3207@phenom.dumpdata.com>
 <20120530150334.GA13349@jshin-Toonie>
 <20120530171754.GA5115@phenom.dumpdata.com>
 <20120530173247.GC15635@x1.osrc.amd.com> <4FC65D34.1060803@zytor.com>
 <20120530175150.GE15438@x1.osrc.amd.com> <4FC66037.6020506@zytor.com>
 <20120530181722.GF15438@x1.osrc.amd.com>
In-Reply-To: <20120530181722.GF15438@x1.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.05.12 at 20:17, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, May 30, 2012 at 11:00:23AM -0700, H. Peter Anvin wrote:
> The other place where we use the amd_safe variants is an obscure K8,
> revC and earlier fix for _some_ BIOSen and this hasn't bitten us yet
> so I'm assuming people haven't run xen on such boxes yet. Does it need
> fixing? Probably, if we really really have to.

This again is something that shouldn't even be attempted under
Xen. The hypervisor, unless really old, does this (and wouldn't
allow the write by any domain - privileged or not - anyway).

There's one more user though - the code triggered by the
"show_msr=" command line option. This one indeed requires
rdmsr_safe_regs to be functional (albeit under Xen, once
again, this won't work currently anyway for those MRS on
old CPUs where the special key in %edi is required, which the
emulation code in Xen doesn't support).

Jan

