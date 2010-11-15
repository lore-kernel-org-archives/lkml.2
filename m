Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab0KOFgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 00:36:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51237 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0KOFgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 00:36:48 -0500
Message-ID: <4CE0C7F0.2040407@cn.fujitsu.com>
Date: Mon, 15 Nov 2010 13:41:04 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/4] KVM: MMU: notrap it if gpte's reserved is set
References: <4CDD173E.8010706@cn.fujitsu.com> <4CDD1841.9010300@cn.fujitsu.com> <4CDFC04A.8010907@redhat.com>
In-Reply-To: <4CDFC04A.8010907@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 13:37:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 13:37:12,
	Serialize complete at 2010-11-15 13:37:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2010 06:56 PM, Avi Kivity wrote:
> On 11/12/2010 12:34 PM, Xiao Guangrong wrote:
>> We can past the page fault to guest directly if gpte's reserved
>> is set
>>
> 
> How can that work? shadow_notrap_nonpresent_pte causes a fault with
> PFEC.P=PFEC.RSVD=0, while we need PFEC.P=PFEC.RSVD=1.
> 

Ah, i missed it for a long time, thanks for you point it out.

The same mistake is in 'prefetch' path, i'll fix it in the v2 version.
