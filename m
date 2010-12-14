Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995Ab0LNBtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 20:49:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61109 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758959Ab0LNBtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 20:49:01 -0500
Message-ID: <4D06CE19.9000908@cn.fujitsu.com>
Date: Tue, 14 Dec 2010 09:53:29 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: MMU: don't make direct sp read-only if !map_writable
References: <4D05F5F6.3070909@cn.fujitsu.com> <4D05F62D.9040308@redhat.com>
In-Reply-To: <4D05F62D.9040308@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-14 09:48:58,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-14 09:49:00,
	Serialize complete at 2010-12-14 09:49:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 06:32 PM, Avi Kivity wrote:
> On 12/13/2010 12:31 PM, Xiao Guangrong wrote:
>> Currently, if the page is not allowed to write, then it can drop
>> ACC_WRITE_MASK in pte_access, and the direct sp's access is:
>>     gw->pt_access&  gw->pte_access
>> so, it also removes the write access in the direct sp.
>>
>> There is a problem: if the access of those pages which map thought the
>> same
>> mapping in guest is different in host, it causes host switch direct sp
>> very
>> frequently.
> 
> I just sent a patch to fix this in a different way, please review it.
> 

Your patch is good for me, please ignore this one :-)

Umm, do we need move "access &= ~ACC_WRITE_MASK" into set_spte() then
can remove the same code in the caller?
