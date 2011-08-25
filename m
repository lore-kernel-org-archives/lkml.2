Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab1HYEmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 00:42:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab1HYEmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 00:42:15 -0400
Message-ID: <4E55D2A2.7050808@redhat.com>
Date: Thu, 25 Aug 2011 07:42:10 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/11] KVM: MMU: improve write flooding detected
References: <4E4A10E8.5090705@cn.fujitsu.com> <4E4A1257.5080204@cn.fujitsu.com> <20110823080024.GA2297@amt.cnet> <4E53872B.3070407@cn.fujitsu.com> <20110823123818.GB4261@amt.cnet> <4E53D620.9030304@cn.fujitsu.com> <20110823190939.GA10220@amt.cnet> <4E540AB4.6060905@cn.fujitsu.com> <20110824200540.GA19804@amt.cnet> <20110825020424.GA2542@amt.cnet>
In-Reply-To: <20110825020424.GA2542@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2011 05:04 AM, Marcelo Tosatti wrote:
> >
> >  It could increase the flood count independently of the accessed bit of
> >  the spte being updated, zapping after 3 attempts as it is now.
> >
> >  But additionally reset the flood count if the gpte appears to be valid
> >  (points to an existant gfn if the present bit is set, or if its zeroed).
>
> Well not zero, as thats a common pattern for non ptes.
>

On 32-bit with 4GB RAM, practically anything is a valid gpte.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

