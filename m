Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2B2Upz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:45:55 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:30046 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab2B2Upx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:45:53 -0500
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzz8275bhz2fh668h839h93fh)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F4E8E6A.2020601@am.sony.com>
Date: Wed, 29 Feb 2012 12:45:30 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Oleg Nesterov <oleg@redhat.com>, Denys Vlasenko <vda.linux@googlemail.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Questions about ptrace on a dying process
References: <4F4E6915.1010209@am.sony.com> <m2mx81pi7x.fsf@firstfloor.org>
In-Reply-To: <m2mx81pi7x.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 11:12 AM, Andi Kleen wrote:
> Tim Bird <tim.bird@am.sony.com> writes:
> 
>> ptrace maintainers (and interested parties)...
>>
>> I'm working on a crash handler for Linux, which uses ptrace to retrieve information
>> about a process during it's coredump.  Specifically, from within a core handler
>> program (started within do_coredump() as a user_mode_helper), I would like to make
>> ptrace calls against the dying process.
> 
> The standard approach is to define a core pipe handler and parse the
> elf memory dump.

Yeah - I may be doing something new here.  Android uses ptrace
in debuggerd, which is their crash reporting tool, but they wake
it up with signals before the dying program goes into coredump.

I'm taking a different approach and trying to do initiated
by the coredump feature in Linux.  This makes it so that
a process does not need to be persistently running to capture
these events.

This is on embedded systems, where the dump is not saved.  The dump
is available via stdin to the core pipe handler, but it would be
kind of a pain to wrapper that for random access, which is needed
for stuff like stack unwinding.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

