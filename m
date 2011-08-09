Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab1HITAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:00:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40439 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab1HITAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:00:43 -0400
Message-ID: <4E418388.9050600@zytor.com>
Date: Tue, 09 Aug 2011 13:59:20 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@mit.edu>
CC: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 1/4] x86-64: Allow emulated vsyscalls from user addresses
References: <cover.1312899174.git.luto@mit.edu> <135b827ce7b4e6059f11de631ea4a455e2b433be.1312899174.git.luto@mit.edu>
In-Reply-To: <135b827ce7b4e6059f11de631ea4a455e2b433be.1312899174.git.luto@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2011 09:27 AM, Andy Lutomirski wrote:
>   *
>   *  Vectors   0 ...  31 : system traps and exceptions - hardcoded events
> - *  Vectors  32 ... 127 : device interrupts
> - *  Vector  128         : legacy int80 syscall interface
> - *  Vector  204         : legacy x86_64 vsyscall emulation
> - *  Vectors 129 ... INVALIDATE_TLB_VECTOR_START-1 except 204 : device interrupts
> + *  Vectors  32 ... INVALIDATE_TLB_VECTOR_START-1 : device interrupts, except:
> + *   Vectors 64 ... 66  : legacy x86_64 vsyscall emulation
> + *   Vector  128        : legacy int80 syscall interface
>   *  Vectors INVALIDATE_TLB_VECTOR_START ... 255 : special interrupts
>   *

Hi Andy,

Was there a reason to not use the vectors in the 0x2X range?

	-hpa

