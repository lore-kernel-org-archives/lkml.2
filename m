Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015Ab2J3QaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:30:11 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:22773 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab2J3QaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:30:09 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lr3c7sfw==
X-RZG-CLASS-ID: mo00
Date: Tue, 30 Oct 2012 17:30:06 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Jan Beulich <JBeulich@suse.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v4] xen PVonHVM: move shared_info to reserved
 memory area
Message-ID: <20121030163006.GA26404@aepfle.de>
References: <1351612057-21822-1-git-send-email-olaf@aepfle.de>
 <50900B1D02000078000A586C@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50900B1D02000078000A586C@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21.rev5555 (2012-07-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, Jan Beulich wrote:

> >>> On 30.10.12 at 16:47, Olaf Hering <olaf@aepfle.de> wrote:
> > This is a respin of 00e37bdb0113a98408de42db85be002f21dbffd3
> > ("xen PVonHVM: move shared_info to MMIO before kexec").
> > 
> > Currently kexec in a PVonHVM guest fails with a triple fault because the
> > new kernel overwrites the shared info page. The exact failure depends on
> > the size of the kernel image. This patch moves the pfn from RAM into an
> > E820 reserved memory area.
> 
> One thing that occurred to me only now: How is this relocation
> of the shared info going to help with the vCPU info placement?
> You can't undo this, nor can you re-register these areas to be
> put in a different location (of course, both of there could be
> implemented in the hypervisor). Yet the hypervisor writes to
> some of these areas' fields as much as it does write to the
> shared info structure itself.

Maybe the wording "move" is a bit misleading in this patch. 

A single "move" of the actual pfn happens during boot, that is when a
PVonHVM enabled guest kernel does the XENMAPSPACE_shared_info operation.
It moves the pfn of the shared info page from the location the hvmloader
initially configured to this new pfn (0xfffff -> 0xfe700).
Another relocation does not happen at runtime, AFAIK.

The "move" which this patch does is more a source level move in the
sense that RESERVE_BRK (which is somewhere in the middle of RAM) is not
used anymore. Instead a pfn in an E820_Reserved area is used, see
xen-unstable changeset 26108:79185dcdf558 "hvmloader: Reserve
FE700000-FE800000 in physical memory map for guest use."


Olaf
