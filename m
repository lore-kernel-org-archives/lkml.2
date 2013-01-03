Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab3ACRtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 12:49:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36311 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab3ACRtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 12:49:07 -0500
Message-ID: <50E5C47B.6060707@zytor.com>
Date: Thu, 03 Jan 2013 09:48:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v5 00/12] x86/microcode: Early load microcode
References: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com> <20130103174455.GA7350@localhost.localdomain>
In-Reply-To: <20130103174455.GA7350@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 09:44 AM, Konrad Rzeszutek Wilk wrote:
>
> A couple of questions - why the usage of native_[read|write]_msr? I get the
> __native_cpuid variant, but I am not sure I understand why you are using
> the native_* variants. Especially as this code ends up being called on
> Xen and lguest (at least on 64-bit) and probably should go through the
> paravirt interfaces.
>

For Xen, the early microcode update should be done in the hypervisor launch.

However, if you have a more specific flow in mind please clarify.  Keep 
in mind Xen is largely a black box to non-Xen developers
(#include <stdrant.h>).

	-hpa

P.S. Since when is lguest 64-bit?  Did I miss something?

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

