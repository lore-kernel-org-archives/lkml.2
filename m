Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab2EHTPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 15:15:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:1073 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab2EHTPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 15:15:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="138330412"
Message-ID: <4FA9709F.6020700@linux.intel.com>
Date: Tue, 08 May 2012 12:14:39 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Jarkko Sakkinen <jarkko.sakkinen@intel.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>
Subject: Re: [PATCH 02/23] x86, realmode: realmode.bin infrastructure
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com> <1336501366-28617-3-git-send-email-jarkko.sakkinen@intel.com> <20120508185349.GA12013@merkur.ravnborg.org>
In-Reply-To: <20120508185349.GA12013@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 11:53 AM, Sam Ravnborg wrote:
+# How to compile the 16-bit code.  Note we always compile for -march=i386,
+# that way we can complain to the user if the CPU is insufficient.
+KBUILD_CFLAGS	:= $(LINUXINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ \
+		   -DDISABLE_BRANCH_PROFILING \
+		   -Wall -Wstrict-prototypes \
+		   -march=i386 -mregparm=3 \
+		   -include $(srctree)/$(src)/../../boot/code16gcc.h \
+		   -fno-strict-aliasing -fomit-frame-pointer \
+		   $(call cc-option, -ffreestanding) \
+		   $(call cc-option, -fno-toplevel-reorder,\
+			$(call cc-option, -fno-unit-at-a-time)) \
+		   $(call cc-option, -fno-stack-protector) \
+		   $(call cc-option, -mpreferred-stack-boundary=2)
+KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__


> 
> How much is needed to avoid this misuse of kernel-internal build rules?
> This was and is an ugly hack.
> 

It is more or less the same as for arch/x86/boot and other things.  If
there are better ways to do it suggestions are very much appreciated.

However, it is a bit of a tricky bit because we need *some* of the bits
of the target compiler configuration and some not (this is the same as
arch/x86/boot etc.)  It is not "pure target" but it's also most
definitely not host.

	-hpa
