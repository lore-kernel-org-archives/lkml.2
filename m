Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab0KOFaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 00:30:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56545 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab0KOFaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 00:30:08 -0500
Message-ID: <4CE0C660.5000109@cn.fujitsu.com>
Date: Mon, 15 Nov 2010 13:34:24 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/4] KVM: MMU: don't drop spte if overwrite it from W
 to RO
References: <4CDD173E.8010706@cn.fujitsu.com> <4CDFBF5B.10706@redhat.com>
In-Reply-To: <4CDFBF5B.10706@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 13:30:31,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 13:30:31,
	Serialize complete at 2010-11-15 13:30:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2010 06:52 PM, Avi Kivity wrote:
> On 11/12/2010 12:30 PM, Xiao Guangrong wrote:
>> We just need flush tlb if overwrite a writable spte with a read-only one
>>
> 
> What are the advantages?  Avoid playing with rmap, and avoid a window
> where the spte is missing?
> 

Both, but only the first was in my mind when i'm making the patch :-)
