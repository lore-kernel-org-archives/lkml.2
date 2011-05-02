Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445Ab1EBWND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:13:03 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33818 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab1EBWNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:13:01 -0400
Subject: Re: Long timeout when booting >= 2.6.38
From: john stultz <johnstul@us.ibm.com>
To: Christian Hoffmann <email@christianhoffmann.info>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4DBF1DBD.40108@christianhoffmann.info>
References: <4DBEFCBA.3070501@christianhoffmann.info>
	 <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>
	 <4DBF1DBD.40108@christianhoffmann.info>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 15:12:54 -0700
Message-ID: <1304374374.3226.20.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 23:10 +0200, Christian Hoffmann wrote:
> >> Hrm. The delay in the dmesg logs doesn't really seem to correlate that
> >> closely with the delayed tsc calibration. Hrmm..
> 
> I also ran it now with calltrace_debug:
[snip]
> [    1.455253] calling  pci_apply_final_quirks+0x0/0x105 @ 1
> [    1.455259] pci 0000:00:01.0: MSI quirk detected; subordinate MSI 
> disabled
> [  146.830206] pci 0000:01:05.0: Boot video device
> [  146.830219] PCI: CLS 64 bytes, default 64
> [  146.830224] initcall pci_apply_final_quirks+0x0/0x105 returned 0 
> after 141967734 usecs

Hrm.. Again, this looks more like something off with the MSI quirk bits.

I'm a little stumped right off how the refined calibration would impact
this. The only difference would be that the TSC clocksource isn't
registered at that point (because the refined calibration pushed the
registration back a bit), so you might be using the HPET at this point
instead of the TSC.

Let me know how the clocksource= boot bits changed things.

thanks
-john


