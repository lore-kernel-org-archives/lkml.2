Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab2AYG0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 01:26:23 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:48707 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab2AYG0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 01:26:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Earl Chew <echew@ixiacom.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <adobriyan@gmail.com>
Subject: Re: [PATCH] Support single byte reads from integers published in procfs by kernel/sysctl.c
References: <4F1C5995.3060806@ixiacom.com> <m1fwf6pjal.fsf@fess.ebiederm.org>
	<4F1D8180.9030509@ixiacom.com> <m1mx9enzr0.fsf@fess.ebiederm.org>
	<4F1D8F37.6020806@ixiacom.com>
	<20120124145037.f8223e37.akpm@linux-foundation.org>
Date: Tue, 24 Jan 2012 22:28:51 -0800
In-Reply-To: <20120124145037.f8223e37.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 24 Jan 2012 14:50:37 -0800")
Message-ID: <m1hazke1ng.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Ue0RarVMZXRR/Xi6xnRBG4a5a2w+70fU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 23 Jan 2012 08:47:51 -0800
> Earl Chew <echew@ixiacom.com> wrote:
>
>> > Rereading different bytes of the integer multiple times when the integer
>> > may be changing does not seem like a reasonable implementation.
>> 
>> Yes. I agree with you. I shall re-work the patch as per your suggestion.
>
> Yes, this is a bug and procfs should support byte-at-a-time reading of these
> strings.  And yes, they are strings!  Of digits.
>
> We fixed an instance of this in procfs a while ago (maybe a year ago?).
> But I forget where it was.  It is surprising that a bug of this nature
> survived so long.

In the one value per file take on things where the expectation and
normal practice is to read or write the entire file not just a little
bit of it, I don't think it is that surprising.

At the same time I am more embarrassed that not long ago a bug was added
to sysctl where if someone makes a sysctl file pollable and then removes
the module we can oops the kernel merely by keeping that file open.  So
far we are safe because no one has used the polling support on anything
that is modular but... 

Eric
