Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab1GNXI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 19:08:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43755 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932437Ab1GNXIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 19:08:55 -0400
Date: Fri, 15 Jul 2011 00:04:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Waychison <mikew@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
Message-ID: <20110715000454.07c67429@lxorguk.ukuu.org.uk>
In-Reply-To: <CAGTjWtCL-4kqHdQsKHTwCC58y9nqHsJXqxpyygRi3qFvUsqVWw@mail.gmail.com>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
	<1310675693-9204-2-git-send-email-mikew@google.com>
	<20110714153113.31ffdeea.akpm@linux-foundation.org>
	<4E1F6F32.7040504@zytor.com>
	<CAGTjWtCL-4kqHdQsKHTwCC58y9nqHsJXqxpyygRi3qFvUsqVWw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011 15:40:03 -0700
Mike Waychison <mikew@google.com> wrote:

> On Thu, Jul 14, 2011 at 3:35 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 07/14/2011 03:31 PM, Andrew Morton wrote:
> >>
> >> sys_iopl() is missing asmlinkage.
> >>
> >> It would be far more conventional to use cond_syscall().  Perhaps by
> >> adding a CONFIG_X86 area into kernel/sys_ni.c
> >>
> >> fyi, I'm offering special deals on checkpatch.pl site licenses this month.
> >
> > Again, I don't think this makes sense as a compile-time-only option.
> 
> echo "enabled" > /proc/sys/kernel/iopl_available
> echo "disabled" > /proc/sys/kernel/iopl_available
> echo "locked" > /proc/sys/kernel/iopl_available

In all these cases if I can obtain module loading permission or I use the
privileges required to operate these calls for something else then I can
replace them anyway, so "locked" is meaningless.
