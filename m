Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706Ab0KRQll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:41:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab0KRQlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:41:40 -0500
Message-ID: <4CE5573E.4050100@redhat.com>
Date: Thu, 18 Nov 2010 18:41:34 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] KVM: MMU: don't drop spte if overwrite it from
 W to RO
References: <4CE355A0.6020907@cn.fujitsu.com> <4CE355CA.80106@cn.fujitsu.com> <20101117154241.GB18959@amt.cnet> <4CE3FB74.8050705@redhat.com> <4CE4D1F8.7090701@cn.fujitsu.com> <20101118153240.GE14327@amt.cnet>
In-Reply-To: <20101118153240.GE14327@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 05:32 PM, Marcelo Tosatti wrote:
> >  >>  There is no need to flush on sync_page path since the guest is
> >  >>  responsible for it.
> >  >>
> >  >
> >  >   If we don't, the next rmap_write_protect() will incorrectly decide that
> >  >  there's no need to flush tlbs.
> >  >
> >
> >  Maybe it's not a problem if guest can flush all tlbs after overwrite it?
> >  Marcelo, what's your comment about this?
>
> It can, but there is no guarantee. Your patch is correct.

We keep tripping on the same problem again and again.  spte.w (and 
tlb.pte.w) is multiplexed between guest and host, hence we cannot trust 
the guest regarding its consistency.

I wish we had a systematic way of dealing with this.

-- 
error compiling committee.c: too many arguments to function

