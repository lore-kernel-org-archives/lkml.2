Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab1GOPli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:41:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5585 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1GOPlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:41:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=uiRymEOXvrS/O1V9R0O+nvqtvQAnCPvjZh9+qCl83Um1VgqSrWUfyyjgMUDu1fcQa
	ileem3ZmgUT288x2lYX6w==
MIME-Version: 1.0
In-Reply-To: <4E1F0BC9.1040102@kernel.org>
References: <4E1F0BC9.1040102@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 15 Jul 2011 09:41:15 -0600
Message-ID: <CAErSpo5CzU2j81moWLsHDoRxTs5107=AEAWYi3ezy3Xfw86qiQ@mail.gmail.com>
Subject: Re: [PATCH] x86, ioapic: Clean up ioapic/apic_id usage
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 9:31 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> While checking irte dump in dmesg, the print out is confused ioapic index
> and real io apic id.
>
> IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000001 SID:00FF SQ:0 SVT:1)
> IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:00FF SQ:0 SVT:1)
>
> The system first ioapic id is 1.
>
> While looking at the code, apic_id sometime is referred to index of ioapic, but
> sometime is used for real apic id. and some even use apic for real apic id.
> It is very confusing.
>
> So try to limit apic_id to be real apic id for ioapic.
> and use ioapic for ioapic index in the array.

It seems like this patch is doing two things at once, and it would be
easier to understand & review if they were split into separate
patches:

  1) The code cleanup that renames parameters & local variables so
they're used consistently, but makes no difference in operation or
dmesg output.
  2) The printk changes to fix the dmesg output.

Bjorn
