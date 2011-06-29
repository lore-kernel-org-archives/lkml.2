Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1F2LHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:07:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57926 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab1F2LHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:07:46 -0400
Message-ID: <4E0B07F0.5020503@cn.fujitsu.com>
Date: Wed, 29 Jun 2011 19:09:36 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 07/22] KVM: MMU: cache mmio info on page fault path
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FCA8.3050401@cn.fujitsu.com> <4E0AE6D5.6080205@redhat.com>
In-Reply-To: <4E0AE6D5.6080205@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-29 19:07:07,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-29 19:07:07,
	Serialize complete at 2011-06-29 19:07:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 04:48 PM, Avi Kivity wrote:
> On 06/22/2011 05:31 PM, Xiao Guangrong wrote:
>> If the page fault is caused by mmio, we can cache the mmio info, later, we do
>> not need to walk guest page table and quickly know it is a mmio fault while we
>> emulate the mmio instruction
> 
> Does this work if the mmio spans two pages?
> 

If the mmio spans two pages, we already split the emulation into two parts,
and the mmio cache info is only matched for one page, so i thinks it works
well :-)
