Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab2HSFZO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 01:25:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59306 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab2HSFZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 01:25:10 -0400
Message-ID: <503078A2.9030204@zytor.com>
Date: Sat, 18 Aug 2012 22:24:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces for
 early load ucode
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com> <1345277729-8399-5-git-send-email-fenghua.yu@intel.com> <20120818224442.GB32120@khazad-dum.debian.net> <3E5A0FA7E9CA944F9D5414FEC6C71220077879BF@ORSMSX105.amr.corp.intel.com>
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C71220077879BF@ORSMSX105.amr.corp.intel.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2012 07:38 PM, Yu, Fenghua wrote:
> 
> In this early phase, detecting vendor in initrd is much simpler code.
> Otherwise, detecting vendor by cpuid (and without cpuid) needs
> similar but different code as existing functions and coding would be
> awkward.
> 

I'm confused by this statement.  Getting the vendor from CPUID is a few
lines of code, and non-CPUID processors don't support microcode loading.

> Why name it ".hex" when you're loading binary data?  I suggest ".bin".  It
> is confusing to have .hex there, since you're not dealing with the Intel HEX
> format, nor anything text-like.

Actually I think we can also skip one level of indirection here... no
need to mention "microcode" twice.

kernel/x86/microcode/GenuineIntel or GenuineIntel.bin seems good
enough... the idea here of course is that the string can come from CPUID.

	-hpa
