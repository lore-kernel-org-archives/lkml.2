Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab2HTM0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 08:26:14 -0400
Received: from mail.x86-64.org ([217.9.48.20]:51575 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab2HTM0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 08:26:11 -0400
Date: Mon, 20 Aug 2012 14:26:00 +0200
From: Borislav Petkov <bp@amd64.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 01/11] Documentation/x86: Early load microcode
Message-ID: <20120820122600.GB16125@aftab.osrc.amd.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
 <1345277729-8399-2-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345277729-8399-2-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 01:15:19AM -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Documenation for early load microcode methodology.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  Documentation/x86/earlyucode.txt |   43 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 43 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/x86/earlyucode.txt
> 
> diff --git a/Documentation/x86/earlyucode.txt b/Documentation/x86/earlyucode.txt
> new file mode 100644
> index 0000000..d8966d6
> --- /dev/null
> +++ b/Documentation/x86/earlyucode.txt

Let's call the doc file "early-microcode.txt" like the rest of the
microcode-related files in the tree.

> @@ -0,0 +1,43 @@
> +Early load microcode
> +====================
> +By Fenghua Yu <fenghua.yu@intel.com>
> +
> +Kernel can update microcode in early phase of boot time. Loading microcode early
> +can fix CPU issues before they are observed during kernel boot time.
> +
> +Microcode is stored in initrd file. The microcode is read from the initrd file
			 ^
			an

> +and loaded to CPU's during boot time.

I think you mean the plural "CPUs" here.

> +
> +The format of the combined initrd image is microcode in cpio format followed by
> +initrd image (maybe compressed). Kernel parses the combined initrd image during
  ^
  the

> +boot time. The microcode file in cpio name space is:

Here and below, can we call the microcode file the "microcode container"
to differentiate from the other "file" types?


s/time//

> +kernel/x86/microcode/GenuineIntel/microcode.hex
> +
> +During BSP boot (before SMP starts), if kernel finds the microcode file in the
					  ^
					 the

> +initrd file, it parses the microcode and saves matching microcode in memory.

			s/the microcode/it/

> +If matching microcode is found, it will be uploaded in BSP and later on in all

I guess "uploaded to the BSP" is more fitting here...

> +AP's.

 APs.

> +
> +The saved microcode in memory will be used to upload micorcode when system
> +resumes from sleep.

Simplify:

"The cached microcode patch is applied when the CPU resumes from a sleep state."

> +
> +In the past, user can issue command to load microcode during run time.

Delete that sentence, it is not needed.

> +There are two user space interfaces to load microcode, either through
> +/dev/cpu/microcode interface or through reload file in sysfs.

		s/interface//

"... or through /sys/devices/system/cpu/microcode/reload."


> +
> +Now user can choose any of the three methods to update microcode during boot
> +time or later during run time.

That sounds strange, maybe say something like:

"In addition to those two, the early loading method described here is
the third method with which microcode can be uploaded to a system's
CPUs."

> +
> +The following sample script shows how to generate a new combined initrd file in

		s/sample/example/

> +/boot/initrd-3.5.0.ucode.img with original microcode microcode.hex and
						       ^
						       in

> +original initrd image /boot/initrd-3.5.0.img.
> +
> +mkdir initrd
> +cd initrd
> +cp ../microcode.hex kernel/x86/microcode/GenuineIntel/microcode.hex
> +find .|cpio -oc >../ucode.cpio
> +cd ..
> +cat ucode.cpio /boot/initrd-3.5.0.img >/boot/initrd-3.5.0.ucode.img
> +
> +The generated /boot/initrd-3.5.0.ucode.img can be used as initrd file to load
							    ^
							    an

> +microcode during early boot time.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
