Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab1INJ5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 05:57:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263Ab1INJ5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 05:57:21 -0400
Message-ID: <4E707A78.4050603@redhat.com>
Date: Wed, 14 Sep 2011 12:57:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 06/11] KVM: MMU: cleanup FNAME(invlpg)
References: <4E5C4C20.3000403@cn.fujitsu.com> <4E5C4CA3.6030808@cn.fujitsu.com> <4E6F37B4.2080405@redhat.com> <4E6FA189.7080607@cn.fujitsu.com>
In-Reply-To: <4E6FA189.7080607@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 09:31 PM, Xiao Guangrong wrote:
> >>  @@ -675,36 +684,20 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
> >>
> >>            sp = page_header(__pa(sptep));
> >>            if (is_last_spte(*sptep, level)) {
> >>  -            int offset, shift;
> >>  -
> >>                if (!sp->unsync)
> >>                    break;
> >>
> >>  -            shift = PAGE_SHIFT -
> >>  -                  (PT_LEVEL_BITS - PT64_LEVEL_BITS) * level;
> >>  -            offset = sp->role.quadrant<<   shift;
> >>  -
> >>  -            pte_gpa = (sp->gfn<<   PAGE_SHIFT) + offset;
> >>  +            pte_gpa = FNAME(get_first_pte_gpa)(sp);
> >
> >
> >  Here is can be used for L2 - I think we can use 2MB host pages to back 4MB guest mappings.
> >
>
> Only unsync shadow page is fetched here, and its level is always 1.
>

Right.

-- 
error compiling committee.c: too many arguments to function

