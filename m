Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1G0LIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 07:08:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab1G0LIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 07:08:34 -0400
Message-ID: <4E2FF1AA.3020507@redhat.com>
Date: Wed, 27 Jul 2011 14:08:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/11] KVM: MMU: improve write flooding detected
References: <4E2EA3DB.7040403@cn.fujitsu.com> <4E2EA5D2.8040804@cn.fujitsu.com> <4E2FD8F7.40303@redhat.com> <4E2FE674.8070202@cn.fujitsu.com>
In-Reply-To: <4E2FE674.8070202@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 01:20 PM, Xiao Guangrong wrote:
> >>    }
> >
> >  I think this is a little dangerous.  A guest kernel may be instantiating multiple gptes on a page fault, but guest userspace hits only one of them (the one which caused the page fault) - I think Windows does this, but I'm not sure.
> >
>
> I think this case is not bad: if the guest kernel need to write multiple gptes (>=3),
> it will cause many page fault, we do better zap the shadow page and let it become writable as
> soon as possible.
> (And, we have pte-fetch, it can quickly establish the mapping for a new shadow page)

Actually, what should save us is unsync pages.  Why are we hitting this 
path at all?

-- 
error compiling committee.c: too many arguments to function

