Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab1GOAtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 20:49:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30752 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab1GOAtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 20:49:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=WN4a00NO9sl3trIbCiN2zokD1aVAhdwStSvzU3FRubUhWeX1y/D2KgPJTGdIOkHBU
	5VolbA6KHot7S6Ygevr+Q==
MIME-Version: 1.0
In-Reply-To: <20110715003912.149dcedd@lxorguk.ukuu.org.uk>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
 <1310675693-9204-2-git-send-email-mikew@google.com> <20110714234248.7ed43534@lxorguk.ukuu.org.uk>
 <CAGTjWtDHH_VXXAsh5WPspTwPEhzcKi4_Jno7w=jReiS7HSALQw@mail.gmail.com>
 <20110715000037.3fc1670a@lxorguk.ukuu.org.uk> <CAGTjWtA5qobWAZb=SbM1y5SFtDKPuJVuAsbDKmkaxxL7mA6OKg@mail.gmail.com>
 <20110715003912.149dcedd@lxorguk.ukuu.org.uk>
From: Mike Waychison <mikew@google.com>
Date: Thu, 14 Jul 2011 17:48:48 -0700
Message-ID: <CAGTjWtD+5cZxQiE+tikUyz2SNgm3bR95GE2veevEv15cPX1E9A@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 4:39 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> In my case, I simply don't want these "features", which is why I took
>> the compile time approach to turning this stuff off.  I realize that
>> these syscalls (and the /dev/port interface) are not comprehensive (I
>> didn't say they were either).  I'm happy though to take suggestions
>
> Indeed - but from the point of view of doing the job to a standard for
> an upstream kernel there ought to be a meaningful testable definition of
> what the security shift you achieve is.
>
>> for stuff I probably should be disabling considering my goal of making
>> it difficult for root to compromise a system.  And yes, modules are
>> disabled :)
>
> If you have CAP_SYS_RAWIO and some of the other interfaces you only think
> it is - the kiddies toolkits already include out of the box direct module
> loading hacks (in fact its fairly easy if you've got GPU PCI access to
> just put the module into video memory so that only the patching needs to
> be done and the module internal addresses are all fixed and can be
> arranged on a suitably convenient target address)
>
> So really there needs to be a definition of what you are trying to
> achieve. My own guess is that for
>
>        "Disallow direct access paths to hardware"
>
> the actual answer is 'revoke RAWIO' and then give it back to very
> specific selected code in very specific selected ways or possibly in some
> cases where rawio is needed for stuff that shouldn't be by writing new
> driver bits to provide the proper interface that we are lacking ?
>
> So lets turn the question around a moment - what breaks if you simply
> take CAP_SYS_RAWIO away from everything ?
>

Alright, I see your point.   ISTR that CAP_SYS_RAWIO was required for
accessing block devices directly, but this doesn't seem to be the
case.

I think the approach I'll try next is to try and drop it with
PR_CAPBSET_DROP from early userspace's init.

Any other vectors you would suggest to keep the kiddies away?
