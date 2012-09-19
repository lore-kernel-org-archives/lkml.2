Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab2ISVQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 17:16:10 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60075 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2ISVQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 17:16:08 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D43167@ORSMSX108.amr.corp.intel.com>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
 <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com>
 <5057BE59.3050903@linaro.org> <20120918180200.GA2281@netboy.at.omicron.at>
 <5058BD9E.30909@linaro.org> <20120919045038.GA2248@netboy.at.omicron.at>
 <5059F367.5020104@linaro.org> <20120919170347.GA2232@netboy.at.omicron.at>
 <505A06BD.6000406@linaro.org> <CALCETrUAiLXvxYMnNDvdUSFkno+v+P_XGirOYch-k8dUG05jpw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F19D43167@ORSMSX108.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 19 Sep 2012 14:15:46 -0700
Message-ID: <CALCETrVc0Lk62_jgB69h62g5pTPt8RFesQf6nOg7xLsb3GqWxw@mail.gmail.com>
Subject: Re: [PATCH 0/6][RFC] Rework vsyscall to avoid truncation/rounding
 issue in timekeeping core
To: "Luck, Tony" <tony.luck@intel.com>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 1:50 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> Does anything except the vDSO actually use the vDSO data page?  It's
>> mapped as part of the vDSO image (i.e. at a non-constant address), and
>> it's not immediate obvious how userspace would locate that page.
>
> Just for reference - on ia64 the address of the entry point for the magic
> fast system call page is passed to each applications via the "auxv" structure
> that exec(2) drops at the top of stack after args/env in the AT_SYSINFO
> entry. Apps look for it to find out where to jump for fast system call entry
> (if it isn't there, they fall back to regular slow syscall path).
>
> Same method could be used to provide the address of a magic read-only
> for users page that kernel fills with stuff for simple system calls.

Erk.  I'd much rather *not* pass this information to user apps -- if
they only ever access this stuff via the vDSO, then there's no ABI
issue the next time the data structure changes.  (e.g. on x86-64 it's
changed at least twice this year, and nothing noticed.)

--Andy
