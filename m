Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0LGJXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:23:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab0LGJXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:23:03 -0500
Message-ID: <4CFDFCEF.3080708@redhat.com>
Date: Tue, 07 Dec 2010 11:22:55 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: David Sharp <dhsharp@google.com>
CC: rostedt@goodmis.org, linux-kernel@vger.kernel.org, mrubin@google.com,
        kvm-devel <kvm@vger.kernel.org>
Subject: Re: [PATCH 07/15] ftrace: fix event alignment: kvm:kvm_hv_hypercall
References: <1291421609-14665-1-git-send-email-dhsharp@google.com> <1291421609-14665-8-git-send-email-dhsharp@google.com> <4CF9F7AB.8050802@redhat.com> <AANLkTi=H9eSAOKmN8KdKDKiFZdD7DjQC=wa+fqrDpe2q@mail.gmail.com>
In-Reply-To: <AANLkTi=H9eSAOKmN8KdKDKiFZdD7DjQC=wa+fqrDpe2q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 10:38 PM, David Sharp wrote:
> On Sat, Dec 4, 2010 at 12:11 AM, Avi Kivity<avi@redhat.com>  wrote:
> >  On 12/04/2010 02:13 AM, David Sharp wrote:
> >>
> >>  Signed-off-by: David Sharp<dhsharp@google.com>
> >>  ---
> >>    arch/x86/kvm/trace.h |    8 ++++----
> >>    1 files changed, 4 insertions(+), 4 deletions(-)
> >>
> >>  diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> >>  index a6544b8..ab41fb0 100644
> >>  --- a/arch/x86/kvm/trace.h
> >>  +++ b/arch/x86/kvm/trace.h
> >>  @@ -62,21 +62,21 @@ TRACE_EVENT(kvm_hv_hypercall,
> >>          TP_ARGS(code, fast, rep_cnt, rep_idx, ingpa, outgpa),
> >>
> >>          TP_STRUCT__entry(
> >>  -               __field(        __u16,          code            )
> >>  -               __field(        bool,           fast            )
> >>                  __field(        __u16,          rep_cnt         )
> >>                  __field(        __u16,          rep_idx         )
> >>                  __field(        __u64,          ingpa           )
> >>                  __field(        __u64,          outgpa          )
> >>  +               __field(        __u16,          code            )
> >>  +               __field(        bool,           fast            )
> >>          ),
> >>
> >
> >  Looks like a pessimisation.
> >
> >  Before: 24 bytes
> >  After: 32 bytes
> >
> >  (on a 64-bit machine, assuming no packing)
>
> This patch is predicated on packing the event structures. And since
> the ring buffer is 32-bit addressable, I don't attempt to improve
> alignment beyond 32-bit boundaries.

I don't understand this.  Can you elaborate?  What does "32-bit 
addressable" mean?  And "predicated on packing the event structures"?  
Is the structure __attribute__((packed)), or is it not?

-- 
error compiling committee.c: too many arguments to function

