Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934011Ab1IIXKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 19:10:06 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:46429 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098Ab1IIXKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 19:10:05 -0400
Message-ID: <e7392891fba13321668f533c6a0d637b.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110909162606.GC23271@redhat.com>
References: <1315500802.18043.45.camel@dhcp-25-63.brq.redhat.com>
    <20110909001853.GA29319@htj.dyndns.org>
    <201109090754.50272.vda.linux@googlemail.com>
    <93a9bd6624aa6a991d688bfaba766a91.squirrel@webmail.greenhost.nl>
    <20110909162606.GC23271@redhat.com>
Date: Sat, 10 Sep 2011 01:09:58 +0200
Subject: Re: Why I want PTRACE_O_TRACESTOP option
From: "Indan Zupancic" <indan@nul.nu>
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: "Denys Vlasenko" <vda.linux@googlemail.com>, "Tejun Heo" <tj@kernel.org>,
        "Denys Vlasenko" <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: e462de357cb394d64966911c06262bc8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, September 9, 2011 18:26, Oleg Nesterov wrote:
> On 09/09, Indan Zupancic wrote:
>>
>> It is very useful to set options atomically at SEIZE time.
>
> Nobody argues with this.
>
>> Another important reason to make PTRACE_O_TRACESTOP an option is
>> because not everyone uses SEIZE: Users using PTRACE_TRACEME can't
>> set this option at all.
>
> Yes. This was already discussed, PTRACE_TRACEME obviously doesn't
> work if you need the new features. So far it was decided TRACEME
> should be avoided,

How do you want to attach/seize a just forked child without races
in a less ugly way than with TRACEME?

> but perhaps we can add SEIZE_ME. And, unlike
> TRACEME it should probably stop immediately to simplify the
> synchronization with parent. Afaik, any user of TRACEME does
> something like kill(getpid(), SIGSTOP), this doesn't look very
> good.

I let the child send a SIGTERM to itself, so if anything goes wrong
it terminates. It's only needed because you have to set options.

>
> But personally I'd prefer to avoid SEIZE_ME.

Me too. There is no need for it if PTRACE_O_TRACESTOP exists.

Alternatively, if you do want to add it, just allow PTRACE_SEIZE
with zero/own PID to achieve the same.

Greetings,

Indan


