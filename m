Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab1HZJPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:15:11 -0400
Received: from mail2.vodafone.ie ([213.233.128.44]:61038 "EHLO
	mail2.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab1HZJPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:15:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAMhiV05tTHi6/2dsb2JhbAAMNqpPAQEFMgFGEAsNAQoJFg8JAwIBAgFFBg0BBwEBh3K6bIZMBJhFi1Y
Message-ID: <4E57641A.7090909@draigBrady.com>
Date: Fri, 26 Aug 2011 10:15:06 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Jovi Zhang <bookjovi@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        dhowells@redhat.com, roland@redhat.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: fix pipe coredump when core limit is 0
References: <48dnn9u5x3e4qoh8meht42xk.1313966177259@email.android.com> <4E527684.3020206@draigBrady.com> <20110822161914.GA9399@redhat.com> <CACV3sbJjDhzKq8YQEnrTQPVVw7YsZjLe45G5sWaMRBk3+Vxkcg@mail.gmail.com> <20110824110134.GA17362@hmsreliant.think-freely.org> <4E561DF7.4020203@draigBrady.com> <20110825105547.GA23992@hmsreliant.think-freely.org>
In-Reply-To: <20110825105547.GA23992@hmsreliant.think-freely.org>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2011 11:55 AM, Neil Horman wrote:
> On Thu, Aug 25, 2011 at 11:03:35AM +0100, Pádraig Brady wrote:
>>
>> Drats I just noticed another problem with not being able to disable core dumps
>> for a process. The `timeout` command from coreutils now tries to propagate
>> the signal from the process it's monitoring up. But since core dumps
>> can't be disabled, abrt will attribute any crashes to `timeout` rather
>> than what it's monitoring. I'll guess we'll have to revert:
>> http://git.sv.gnu.org/gitweb/?p=coreutils.git;a=commitdiff;h=5a647a0
>>
> That suggests to me that we need another flag that user space can control to
> override this behavior.  It appears we may have one too - the PR_SET_DUMPABLE
> flag in the prctl syscall.  Its not POSIX compliant so you'd have to ifdef it
> into coreutils, but it exists, and sounds like exactly what you'd need in the
> above case.  Looking at do_coredump, clearing the PR_SET_DUMPABLE flag with
> prctl causes __get_dumpable to return 0, which skips all the code in do_coredump
> entirely.  I think thats identical behavior to having a zero core limit skip the
> dump.

This would be the first use of prctl in coreutils,
but I think this should handle things.

thanks for that!
Pádraig.
