Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab1BGD5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 22:57:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39005 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab1BGD5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 22:57:20 -0500
Message-ID: <4D4F6D7C.5090405@zytor.com>
Date: Sun, 06 Feb 2011 19:56:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: castet.matthieu@free.fr
CC: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
References: <4D473FD5.1090903@free.fr> <20110201080223.GB20372@elte.hu> <1296566732.4d4809cc1f963@imp.free.fr> <20110202062632.GA12256@elte.hu> <4D4CA3FD.6000901@zytor.com> <1296924395.4d4d7eeb6f1fe@imp.free.fr>
In-Reply-To: <1296924395.4d4d7eeb6f1fe@imp.free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2011 08:46 AM, castet.matthieu@free.fr wrote:
> 
> Doing the setting in a arch_initcall make it work.
> 

Thinking about it, it's probably the sanest thing to do in the very
short term.  I don't get the #ifdef CONFIG_X86_32 bit in your patch,
though.  We reserve this area even on 64 bits, and so we should
logically do the same thing, if nothing else to avoid gratuitous
differences.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

