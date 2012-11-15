Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946007Ab2KOAOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 19:14:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44959 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299Ab2KOAOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 19:14:30 -0500
Message-ID: <50A433D3.6090301@zytor.com>
Date: Wed, 14 Nov 2012 16:14:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Blower, Melanie" <melanie.blower@intel.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: compilation issue, inline assembly arch/x86/kvm/emulate.c
 fails at -O0
References: <B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com>
In-Reply-To: <B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 11:45 AM, Blower, Melanie wrote:
> [1.] gcc -O0 assembly arch/x86/kvm/emulate.c gets compilation failure -- incorrect register restrictions
> [2.] Full description of the problem/report:
> I'm trying to compile this file at -O0, but gcc chokes in register allocation at the inline assembly.
>
> In the ordinary Linux build, this file compiles with gcc at -O2, without compilation errors.

Compiling with -O0 is not really expected to work (although -O1 *is*), 
although what you are reporting is an actual bug ("+a" : "a" should
either be "+a" or "=a" : "a").

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

