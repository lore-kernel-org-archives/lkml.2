Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab1HZOWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:22:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53417 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab1HZOWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:22:21 -0400
Message-ID: <4E57AC9B.7080209@cn.fujitsu.com>
Date: Fri, 26 Aug 2011 22:24:27 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/11] KVM: MMU: improve write flooding detected
References: <4E4A10E8.5090705@cn.fujitsu.com> <4E4A1257.5080204@cn.fujitsu.com> <20110823080024.GA2297@amt.cnet> <4E53872B.3070407@cn.fujitsu.com> <20110823123818.GB4261@amt.cnet> <4E53D620.9030304@cn.fujitsu.com> <20110823190939.GA10220@amt.cnet> <4E560062.40805@cn.fujitsu.com> <20110825134712.GB4384@amt.cnet> <4E571069.2050701@cn.fujitsu.com> <20110826105328.GA12612@amt.cnet>
In-Reply-To: <20110826105328.GA12612@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-26 22:21:22,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-26 22:21:23,
	Serialize complete at 2011-08-26 22:21:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2011 06:53 PM, Marcelo Tosatti wrote:
> On Fri, Aug 26, 2011 at 11:18:01AM +0800, Xiao Guangrong wrote:
>> On 08/25/2011 09:47 PM, Marcelo Tosatti wrote:
>>
>>> I guess it is OK to be more trigger happy with zapping by ignoring
>>> the accessed bit, clearing the flood counter on page fault.
>>>
>>
>> Yeah, i like this way, is this patch good for you?
> 
> Looks fine, can you rerun kernbench?
> 

Sure, i tested the performance of this way, there is the result:

The origin way:
2m56.561
2m50.651
2m51.220
2m52.199
2m48.066

The way of using accessed bit:
2m51.194
2m55.980
2m50.755
2m47.396
2m46.807

The way of ignoring accessed bit:
2m45.547
2m44.551
2m55.840
2m56.333
2m45.534

I think the result is not bad.
 
