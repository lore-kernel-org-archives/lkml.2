Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab3AGMwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 07:52:49 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29550 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3AGMws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 07:52:48 -0500
Date: Mon, 7 Jan 2013 13:52:11 +0100
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: andrew.cooper3@citrix.com, x86@kernel.org, tglx@linutronix.de,
        kexec@lists.infradead.org, virtualization@lists.linux-foundation.org,
        xen-devel <xen-devel@lists.xen.org>, konrad.wilk@oracle.com,
        maxim.uvarov@oracle.com, mingo@redhat.com, vgoyal@redhat.com,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com, hpa@zytor.com
Subject: Re: [PATCH v3 02/11] x86/kexec: Add extra pointers to transition
 page table PGD, PUD, PMD and PTE
Message-ID: <20130107125211.GB2927@host-192-168-1-59.local.net-space.pl>
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-2-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-3-git-send-email-daniel.kiper@oracle.com>
 <50E55ECF02000078000B2A13@nat28.tlf.novell.com>
 <20130104151542.GD3346@host-192-168-1-59.local.net-space.pl>
 <50E70D8002000078000B336D@nat28.tlf.novell.com>
 <20130104172538.GC3472@host-192-168-1-59.local.net-space.pl>
 <50EAA7F402000078000B34C3@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EAA7F402000078000B34C3@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 09:48:20AM +0000, Jan Beulich wrote:
> >>> On 04.01.13 at 18:25, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> > Right, so where is virtual mapping of control page established?
> > I could not find relevant code in SLES kernel which does that.
>
> In the hypervisor (xen/arch/x86/machine_kexec.c:machine_kexec_load()).
> xen/arch/x86/machine_kexec.c:machine_kexec() then simply uses
> image->page_list[1].

This (xen/arch/x86/machine_kexec.c:machine_kexec_load()) maps relevant
page (allocated earlier by dom0) in hypervisor fixmap area. However,
it does not make relevant mapping in transition page table which
leads to crash when %cr3 is switched from Xen page table to
transition page table.

Daniel
