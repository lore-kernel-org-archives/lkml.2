Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1AKJZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 04:25:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab1AKJZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 04:25:25 -0500
Message-ID: <4D2C21FE.3000406@redhat.com>
Date: Tue, 11 Jan 2011 11:25:18 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM updates for the 2.6.38 merge window
References: <4D2ACFA7.6000502@redhat.com> <AANLkTimOOUjXa7WCTirHRrrLfiev4T9iD7spb2VrB_ET@mail.gmail.com>
In-Reply-To: <AANLkTimOOUjXa7WCTirHRrrLfiev4T9iD7spb2VrB_ET@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 09:31 PM, Linus Torvalds wrote:
> On Mon, Jan 10, 2011 at 1:21 AM, Avi Kivity<avi@redhat.com>  wrote:
> >
> >  - asynchronous page faults, which allow a guest to continue processing
> >  interrupts even when its memory is being paged in; in the case of a Linux
> >  2.6.38+ guest, it will receive a notification that the host is servicing a
> >  page fault, and may switch into another guest process
>
> So quite frankly, I don't like how this was done.
>
> When you touch files like mm/memory.c, you don't just touch them. You
> get sign-offs and acks from the VM maintainers. Seriously.
>
> In this case, I pulled, looked, and then unpulled. I just don't want
> it, and I think the new FAULT_FLAG_MINOR is seriously mis-named and
> hacky.
>
> Is it about atomicity? Is it about IO?

IO.  It means, only allow a minor fault; fail for a major fault.  Can 
you suggest a better name?

>   Why wasn't I notified
> before-hand? Was Andrew cc'd?

Andrew and linux-mm were copied.  Rik was the only one who reviewed (and 
ack'ed) it.  I guess I should have explicitly asked for Nick's review.

How do you want to proceed?  I can pull this patch out and stub out the 
callers in kvm (which will neuter async page faults for the time being, 
but we can live with that), then fix it in the background, or we can try 
to resolve it now.

What are your issues with the patch?

-- 
error compiling committee.c: too many arguments to function

