Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab2EGVQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:16:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53940 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757538Ab2EGVQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:16:16 -0400
Date: Mon, 7 May 2012 23:16:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Shuah Khan <shuahkhan@gmail.com>, mingo@redhat.com, tglx@linutronix.de,
        tigran@aivazian.fsnet.co.uk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] x86: kernel/microcode_core.c simple_strtoul
 cleanup
Message-ID: <20120507211612.GA19700@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuahkhan@gmail.com>,
	mingo@redhat.com, tglx@linutronix.de, tigran@aivazian.fsnet.co.uk,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1336324264.2897.9.camel@lorien2>
 <20120507104943.GA3896@x1.osrc.amd.com>
 <4FA815E3.1030101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FA815E3.1030101@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 11:35:15AM -0700, H. Peter Anvin wrote:
> I'll pick it up.  I presume I have your ack on it?

Yep, sure.

Btw, while at it, I gave the whole sysfs reload thing a critical look
and whether it is at all that useful - this thing gives you microcode
reloading on a single CPU. And what you actually wanna do is reload the
microcode on the whole system, i.e. all cores in succession.

And we don't use the reload thing on AMD, so I was wondering, if you
guys don't find it useful on Intel hw, maybe we can remove it completely
in favor of

$ rmmod microcode; modprobe microcode

which reloads the ucode on each core.

Of course, one can iterate over each core in a shell-loop and write into
the reload file to reload ucode after having updated the ucode image in
/lib/firmware but removing and then modprobing the module is shorter :-)

Hmm?

-- 
Regards/Gruss,
    Boris.
