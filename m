Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab0K3Qr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:47:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50760 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab0K3Qrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:47:55 -0500
Message-ID: <4CF52BC6.9020401@cn.fujitsu.com>
Date: Wed, 01 Dec 2010 00:52:22 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: MMU: fix accessed bit set on prefault path
References: <4CF4C535.8080405@cn.fujitsu.com> <4CF4C587.7080000@cn.fujitsu.com> <20101130132915.GG2187@redhat.com>
In-Reply-To: <20101130132915.GG2187@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-01 00:48:05,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-01 00:48:05,
	Serialize complete at 2010-12-01 00:48:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2010 09:29 PM, Gleb Natapov wrote:

>> +	if (!shadow_accessed_mask)
>> +		return;
>> +
> I don't get this. As far as I can see VMX inits shadow_accessed_mask to
> be zero if ept is enabled. This line here means that we never prefault with ept
> enabled. It is opposite from what it should be.
> 

Since it's no accessed bit on EPT, it's no way to distinguish between actually
accessed translations and prefault.
