Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab1A0K55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:57:57 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:37524 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab1A0K5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:57:55 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFIhi0PEiUl
X-RZG-CLASS-ID: mo00
Date: Thu, 27 Jan 2011 11:57:51 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crash_dump: export is_kdump_kernel to modules,
 consolidate elfcorehdr_addr, setup_elfcorehdr and saved_max_pfn
Message-ID: <20110127105751.GB31360@aepfle.de>
References: <20110125161052.GA20105@aepfle.de>
 <20110127024352.GC20334@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110127024352.GC20334@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, Vivek Goyal wrote:

> Olaf, 
> 
> I think your HVM guest has booted into kdump kernel after the crash and
> now you want Xen PV driver to reset the connection with Dom0.

Yes, thats the case.

> If that's the case, I think instead of exporting is_kdump_kernel(), better
> make use of symbol "reset_devices". Kexec-tools passes this kernel command
> line option to kdump kernel which tells the kernel that it is booting
> in an unreliable environment and device drivers should reset the
> underlying devices and not rely on BIOS to have put devices in a known
> good state. So if reset_devices=1, then Xen PV driver should reset the
> underlying device hence the connection with Dom0.

I will use this variable, its passed unconditionally from the boot.kdump
script.


> Apart from that, moving the code from arch specific section to generic
> code helps. So that bit you can retain and get rid of export of
> is_kdump_kernel() and elfcorehdr_addr.


Andrew, do you want a new patch with the export of elfcorehdr_addr
removed, or can you edit my patch and remove that one line?

Olaf
