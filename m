Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab2LNBcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:32:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41617 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab2LNBcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:32:54 -0500
Message-ID: <50CA81A4.9040702@zytor.com>
Date: Thu, 13 Dec 2012 17:32:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
References: <1355343572-23074-1-git-send-email-stefani@seibold.net> <50C9148C.4040308@zytor.com> <1355378005.24283.11.camel@wall-e> <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com> <1355379433.24701.1.camel@wall-e> <f984cb31-baa5-4176-8e85-37266e2cfb8d@email.android.com> <1355383038.18653.2.camel@wall-e> <CALCETrWmYpEh9pLiohF+yu9FnrVfSNdHB_TQOKL6+LkdTF+cVw@mail.gmail.com> <50CA6E4C.6000305@zytor.com> <CALCETrV1kvhOvDpzTavGb1X9HT+PdEPXJ0H8afs7jzxpcF7Kjg@mail.gmail.com>
In-Reply-To: <CALCETrV1kvhOvDpzTavGb1X9HT+PdEPXJ0H8afs7jzxpcF7Kjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 04:20 PM, Andy Lutomirski wrote:
>
> What you could do is probably arrange (using some linker script magic)
> for a symbol to exist that points at the page *before* the vdso
> starts.  Then just map the vvar page there when starting a compat
> task.  You could then address it using a normal symbol reference by
> tweaking the vvar macro.  (I think this'll access it via the GOT.)
> Alternatively, you could just pick an absolute address -- the page is
> NX, so you don't really need to worry about randomization.
>

The best would probably if we could generate GOTOFF references rather 
than GOT, which again probably means making the vvar page part of the 
vdso proper.  Then, when building the list of vdso pages, we need to 
substitute in the vvar page in the proper place.

I have to admit to kind of thinking this might work well even for the 
64-bit/x32 case, and perhaps even for native 32 bits.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

