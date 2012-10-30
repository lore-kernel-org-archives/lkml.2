Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933980Ab2J3QOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:14:09 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:45131 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933852Ab2J3QOI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 30 Oct 2012 12:14:08 -0400
Message-Id: <50900B1D02000078000A586C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 30 Oct 2012 16:15:09 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Olaf Hering" <olaf@aepfle.de>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v4] xen PVonHVM: move shared_info to
 reserved memory area
References: <1351612057-21822-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1351612057-21822-1-git-send-email-olaf@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.10.12 at 16:47, Olaf Hering <olaf@aepfle.de> wrote:
> This is a respin of 00e37bdb0113a98408de42db85be002f21dbffd3
> ("xen PVonHVM: move shared_info to MMIO before kexec").
> 
> Currently kexec in a PVonHVM guest fails with a triple fault because the
> new kernel overwrites the shared info page. The exact failure depends on
> the size of the kernel image. This patch moves the pfn from RAM into an
> E820 reserved memory area.

One thing that occurred to me only now: How is this relocation
of the shared info going to help with the vCPU info placement?
You can't undo this, nor can you re-register these areas to be
put in a different location (of course, both of there could be
implemented in the hypervisor). Yet the hypervisor writes to
some of these areas' fields as much as it does write to the
shared info structure itself.

Jan

