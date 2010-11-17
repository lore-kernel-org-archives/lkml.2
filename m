Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934000Ab0KQBks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:40:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64200 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933968Ab0KQBkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:40:46 -0500
Message-ID: <4CE3339F.4020200@cn.fujitsu.com>
Date: Wed, 17 Nov 2010 09:45:03 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/4] KVM: MMU: notrap it if gpte's reserved is set
References: <4CDD173E.8010706@cn.fujitsu.com> <4CDD1841.9010300@cn.fujitsu.com> <4CDFC04A.8010907@redhat.com> <4CE0C7F0.2040407@cn.fujitsu.com> <4CE0FAA5.3040902@redhat.com>
In-Reply-To: <4CE0FAA5.3040902@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 09:41:07,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 09:41:07,
	Serialize complete at 2010-11-17 09:41:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 05:17 PM, Avi Kivity wrote:
> On 11/15/2010 07:41 AM, Xiao Guangrong wrote:
>> On 11/14/2010 06:56 PM, Avi Kivity wrote:
>> >  On 11/12/2010 12:34 PM, Xiao Guangrong wrote:
>> >>  We can past the page fault to guest directly if gpte's reserved
>> >>  is set
>> >>
>> >
>> >  How can that work? shadow_notrap_nonpresent_pte causes a fault with
>> >  PFEC.P=PFEC.RSVD=0, while we need PFEC.P=PFEC.RSVD=1.
>> >
>>
>> Ah, i missed it for a long time, thanks for you point it out.
>>
>> The same mistake is in 'prefetch' path, i'll fix it in the v2 version.
> 
> Doesn't access.flat catch this?

Unfortunately, it can't catch this.

> 
> Ideally we'd have a test case to catch this, but it may be hard to write.
> 

Um. i'll do it later.

