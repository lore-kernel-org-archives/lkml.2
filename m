Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab0K3TGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:06:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58289 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab0K3TGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:06:43 -0500
Message-ID: <4CF54C4F.80901@cn.fujitsu.com>
Date: Wed, 01 Dec 2010 03:11:11 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: MMU: fix accessed bit set on prefault path
References: <4CF4C535.8080405@cn.fujitsu.com> <4CF4C587.7080000@cn.fujitsu.com> <20101130132915.GG2187@redhat.com> <4CF52BC6.9020401@cn.fujitsu.com> <20101130175005.GA2924@redhat.com> <4CF53F41.1040503@cn.fujitsu.com> <20101130183833.GB2924@redhat.com>
In-Reply-To: <20101130183833.GB2924@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-01 03:06:53,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-01 03:06:53,
	Serialize complete at 2010-12-01 03:06:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2010 02:38 AM, Gleb Natapov wrote:

>> It can't avoid the page to be evicted again since the page is marked accessed only
>> when spte is droped or updated.
> I still do not understand why are you disabling prefault for ept. Why
> do you want to distinguish between actually accessed translations and
> prefauls? What problem are you trying to fix?
> 

Look at set_spte_track_bits() function:

	if (!shadow_accessed_mask || old_spte & shadow_accessed_mask)
		kvm_set_pfn_accessed(pfn);

It's always mark the page accessed.

But prefault is the speculative path, the prefault address may not be
accessed later(the apf process is killed). under this case, the page is
not really accessed.
