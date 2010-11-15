Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab0KOJRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:17:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab0KOJRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:17:34 -0500
Message-ID: <4CE0FAA5.3040902@redhat.com>
Date: Mon, 15 Nov 2010 11:17:25 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/4] KVM: MMU: notrap it if gpte's reserved is set
References: <4CDD173E.8010706@cn.fujitsu.com> <4CDD1841.9010300@cn.fujitsu.com> <4CDFC04A.8010907@redhat.com> <4CE0C7F0.2040407@cn.fujitsu.com>
In-Reply-To: <4CE0C7F0.2040407@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 07:41 AM, Xiao Guangrong wrote:
> On 11/14/2010 06:56 PM, Avi Kivity wrote:
> >  On 11/12/2010 12:34 PM, Xiao Guangrong wrote:
> >>  We can past the page fault to guest directly if gpte's reserved
> >>  is set
> >>
> >
> >  How can that work? shadow_notrap_nonpresent_pte causes a fault with
> >  PFEC.P=PFEC.RSVD=0, while we need PFEC.P=PFEC.RSVD=1.
> >
>
> Ah, i missed it for a long time, thanks for you point it out.
>
> The same mistake is in 'prefetch' path, i'll fix it in the v2 version.

Doesn't access.flat catch this?

Ideally we'd have a test case to catch this, but it may be hard to write.

-- 
error compiling committee.c: too many arguments to function

