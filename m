Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2A0U11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:27:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50970 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab2A0U10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:27:26 -0500
Message-ID: <4F230899.3020808@zytor.com>
Date: Fri, 27 Jan 2012 12:27:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 1/5] x86/jump-label: Use best default nops for inital
 jump label calls
References: <20120127201442.080360013@goodmis.org> <20120127202030.887128048@goodmis.org>
In-Reply-To: <20120127202030.887128048@goodmis.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 12:14 PM, Steven Rostedt wrote:
> 
> #define JUMP_LABEL_NOP_SIZE 5
> 
> -#define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t" 
> +#ifdef CONFIG_X86_64 +# define JUMP_LABEL_INIT_NOP P6_NOP5 +#else 
> +# define JUMP_LABEL_INIT_NOP 0x3e, 0x8d, 0x74, 0x26, 0x00 +#endif
> 

Why not just use ASM_NOP5_ATOMIC since you have configuration
available here?

	-hpa

