Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab2KHNBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:01:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab2KHNBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:01:31 -0500
Message-ID: <509BAD00.9060600@redhat.com>
Date: Thu, 08 Nov 2012 13:00:48 +0000
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Amnon Shiloh <u3557@miso.sublimeip.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Chris Evans <scarybeasts@gmail.com>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>, u3557@dialix.com.au,
        security@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PT_EXITKILL (Was: pdeath_signal)
References: <20121106152050.GA18218@sergelap> <20121106201428.9D72959201A@miso.sublimeip.com> <20121107150934.GA27606@redhat.com> <509BA2B0.2080204@redhat.com> <20121108124424.GB20917@redhat.com>
In-Reply-To: <20121108124424.GB20917@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 12:44 PM, Oleg Nesterov wrote:
> On 11/08, Pedro Alves wrote:

>> If this isn't inherited by the ptrace child's children, a fork child can
>> end up detached if the tracer dies before it had a chance of setting
>> the PTRACE_O_EXITKILL on the new auto-attached child.
> 
> It is copied like the other options.

Oh, you're right.  I got confused - GDB has code to always set options
on the fork children after PTRACE_EVENT_(V)FORK.   Dunno where that came from.

>> Which sounds like another argument for PTRACE_O_INHERIT, as in:
>> http://sourceware.org/ml/archer/2011-q1/msg00026.html
> 
> 	The point of PTRACE_O_INHERIT would be to attach newly-created threads and
> 	children without causing an event stop and the attendant overhead.
> 
> this is another thing, I guess.

Yes, yes.

-- 
Pedro Alves

