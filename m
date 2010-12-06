Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab0LFNRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:17:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab0LFNRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:17:42 -0500
Message-ID: <4CFCE270.1080500@redhat.com>
Date: Mon, 06 Dec 2010 15:17:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] KVM: MMU: retry #PF for softmmu
References: <4CF76A8B.2040102@cn.fujitsu.com> <4CF76B06.6050708@cn.fujitsu.com> <4CFCB150.40202@redhat.com> <4CFCB983.6020503@cn.fujitsu.com>
In-Reply-To: <4CFCB983.6020503@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 12:22 PM, Xiao Guangrong wrote:
> Hi Avi,
>
> On 12/06/2010 05:48 PM, Avi Kivity wrote:
> >  On 12/02/2010 11:46 AM, Xiao Guangrong wrote:
> >>  Retry #PF for softmmu only when the current vcpu has the same cr3 as
> >>  the time
> >>  when #PF occurs
> >>
> >>  Changelog:
> >>     Just compare cr3 value since It's harmless to instantiate an spte
> >>  for an
> >>     unused translation from Marcelo's comment
> >>
> >
> >  It's not harmless.  We could be in a different process, so we have to
> >  re-fetch the gpte.  Or we could have switched from one nested guest to
> >  another.
> >
>
> But it does this in this patch: re-walk guest page table and fixes guest's
> shadow page (not use any info when apf is occurred)

Right.  Please resend without the walk_addr() changes.  While they're 
correct, I'd like to keep that part simpler.

-- 
error compiling committee.c: too many arguments to function

