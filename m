Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2KURVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:21:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52745 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab2KURVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:21:31 -0500
Message-ID: <50AD0D85.5070906@zytor.com>
Date: Wed, 21 Nov 2012 09:21:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 08/12] x86, boot: Don't check if cmd_line_ptr is accessible
 in misc/decompressor()
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org> <1353482170-10160-9-git-send-email-yinghai@kernel.org>
In-Reply-To: <1353482170-10160-9-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 11:16 PM, Yinghai Lu wrote:
> At that stage, it is already in 32bit protected mode or 64bit mode.
> so we do not need to check if ptr less 1M.
>
> When go from other boot loader (kexec) instead of boot/ code path.
>
> Move out accessible checking out __cmdline_find_option....
>
> So misc.c will parse cmdline and have debug print out.

Your description doesn't seem to match the code, and is incredibly 
confusing to the reader.

The reason why is because you leave out an essential piece of 
information: cmdline.c is included both in 16-bit code and in the 
decompressor (32/64-bit code), so you want to move the test out of the 
shared code.

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

