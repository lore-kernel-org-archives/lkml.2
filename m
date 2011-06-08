Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1FHJbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:31:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63232 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab1FHJbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:31:44 -0400
Message-ID: <4DEF41F6.8050204@cn.fujitsu.com>
Date: Wed, 08 Jun 2011 17:33:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 04/15] KVM: MMU: cache mmio info on page fault path
References: <4DEE205E.8000601@cn.fujitsu.com> <4DEE20EE.7060000@cn.fujitsu.com> <4FA0E9B8-FBB6-49BD-916C-239599136604@suse.de> <4DEF39CB.4020109@cn.fujitsu.com> <3CA39806-D840-414B-816E-99DAB6F8FEBD@suse.de>
In-Reply-To: <3CA39806-D840-414B-816E-99DAB6F8FEBD@suse.de>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-08 17:31:28,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-08 17:31:29,
	Serialize complete at 2011-06-08 17:31:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 05:18 PM, Alexander Graf wrote:

>>
>> Also, when context switched, CR3 is reloaded, mmio cache info can be cleared too. right? :-)
> 
> Only when using SPT. In the NPT case, you will never see cr3 getting reloaded or INVLPG :).
> 

In the NPT case, we only cache the GPA, GVA is not cached (vcpu.arch.mmio_gva is always 0) ;-)
