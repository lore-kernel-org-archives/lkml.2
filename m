Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab2CASSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 13:18:36 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:41438
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753229Ab2CASSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 13:18:35 -0500
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzzz2fh668h839h93fh)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F4FBD65.7020006@am.sony.com>
Date: Thu, 1 Mar 2012 10:18:13 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Questions about ptrace on a dying process
References: <4F4E6915.1010209@am.sony.com> <m2mx81pi7x.fsf@firstfloor.org> <4F4E8E6A.2020601@am.sony.com> <201203010812.54769.vda.linux@googlemail.com>
In-Reply-To: <201203010812.54769.vda.linux@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 11:12 PM, Denys Vlasenko wrote:
> On Wednesday 29 February 2012 21:45, Tim Bird wrote:
>> This is on embedded systems, where the dump is not saved.  The dump
>> is available via stdin to the core pipe handler, but it would be
>> kind of a pain to wrapper that for random access, which is needed
>> for stuff like stack unwinding.
> 
> Stack unwinding only requires the stack data and knowledge
> of the mapped binary and library files. You can parse coredump's ELF header,
> and skip all sizable data segments which you won't need anyway.
> 
> I estimate that usually you will need to save only ~150k of data
> in order to produce a stacktrace, and even then,
> only because Linux pre-allocates ridiculously large
> stack for every new process - 132k. It can easily be reduced
> to something saner with one-line patch.

My budget for each crash report is about 8k.  I have to do
the unwind at the time of the crash (on target) (and without
symbols - these are added later on a host).  Given the other
stuff I want to save, saving the whole stack is usually not
an option, and saving a coredump is out of the question.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

