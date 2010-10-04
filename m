Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab0JDSTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:19:43 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53924 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab0JDSTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:19:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20100917205946.GF2522@local>
	<m139t451b4.fsf_-_@fess.ebiederm.org>
	<20100924104555.GC1819@silverbox.local>
	<m1hbhfcbdo.fsf@fess.ebiederm.org>
	<20100924173106.GA4966@silverbox.local>
	<m14ode662q.fsf@fess.ebiederm.org> <20100925003308.GA29910@suse.de>
	<m1wrqa4mg5.fsf@fess.ebiederm.org> <20100926192142.GA7252@kroah.com>
	<m1iq1s86jk.fsf_-_@fess.ebiederm.org>
	<20101004123447.GB9961@silverbox.local>
Date: Mon, 04 Oct 2010 11:19:34 -0700
In-Reply-To: <20101004123447.GB9961@silverbox.local> (Hans J. Koch's message
	of "Mon, 4 Oct 2010 14:34:47 +0200")
Message-ID: <m1pqvp7rd5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Hans J. Koch" <hjk@linutronix.de>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 5/5] uio: Implement hotunplug support, using libunload
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Hans J. Koch" <hjk@linutronix.de> writes:

> On Sun, Sep 26, 2010 at 03:49:03PM -0700, Eric W. Biederman wrote:
>> 
>> With this change it is possible to remove a module that implements
>> a uio device, or to remove the underlying hardware device of a uio
>> device withot crashing the kernel, or causing user space more problems
>> than just an I/O error.
>
> Well, that I/O error can also be a segfault if userspace accesses
> memory previously mmap'ed. So a userspace program needs to properly
> handle -EIO from read(), and has to handle SIG_SEGV. 

It is SIG_BUS (just like truncate), but yes.  If userspace doesn't
handle there error it can go down.  All of which is a better state
then the current version where the kernel crash if you hotunplug
a uio device.

> This should also
> be mentioned in Documentation/DocBook/uio-howto.tmpl.
> Or do you have a better solution?

A better solution for?

Eric
