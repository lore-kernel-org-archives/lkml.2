Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0JEQyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:54:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48140 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab0JEQx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:53:59 -0400
Date: Tue, 5 Oct 2010 18:53:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: hpa@zytor.com, linux-tip-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        torvalds@linux-foundation.org, ryan@innosecc.com, tglx@linutronix.de
Subject: Re: [tip:x86/cpu] x86, cpu: Fix X86_FEATURE_NOPL
Message-ID: <20101005165356.GA6569@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@linux.intel.com>, hpa@zytor.com,
	linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
	mingo@redhat.com, torvalds@linux-foundation.org, ryan@innosecc.com,
	tglx@linutronix.de
References: <20101004073127.GA20305@liondog.tnic>
 <tip-366d4a43b1a7a861c356a0e407c4f03f454d42ea@git.kernel.org>
 <20101005094712.GA5626@a1.tnic>
 <4CAB52AD.60502@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4CAB52AD.60502@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>
Date: Tue, Oct 05, 2010 at 09:30:37AM -0700

> On 10/5/2010 2:47 AM, Borislav Petkov wrote:
> >
> >tag it for -stable too?
> >
> 
> What is the flaw that justifies it for stable, or even .36?  It
> seems relatively harmless, with at most a very minor performance
> issue, unless I'm missing something?

I was thinking more along the lines of this being partially broken
when supplying non-constant arguments to cpu_has(), something like
<arch/x86/kernel/cpu/proc.c:show_cpuinfo()>, for example. But all this
could cause is /proc/cpuinfo not to report the "nopl" feature bit. I
guess this is too minor an issue to even to be considered for stable.

-- 
Regards/Gruss,
Boris.
