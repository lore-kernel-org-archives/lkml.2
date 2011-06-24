Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254Ab1FXCCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 22:02:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52701 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab1FXCCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 22:02:31 -0400
Message-ID: <4E03F0AE.8010700@cn.fujitsu.com>
Date: Fri, 24 Jun 2011 10:04:30 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 21/22] KVM: MMU: mmio page fault support
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FDE0.5080800@cn.fujitsu.com> <20110622215940.GA30064@amt.cnet> <4E02B0BE.7070003@cn.fujitsu.com> <20110623142134.GA12181@amt.cnet> <4E037E21.6010203@cn.fujitsu.com> <20110623201319.GA19483@amt.cnet>
In-Reply-To: <20110623201319.GA19483@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-24 10:02:03,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-24 10:02:03,
	Serialize complete at 2011-06-24 10:02:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2011 04:13 AM, Marcelo Tosatti wrote:

>> No, not all no mmio spte is considered a genuine EPT misconfig, as the above
>> case, we can get !is_mmio_spte(), but it is not the genuine EPT misconfig
>> since it is caused by shadow page zapped
> 
> I mean it must be
> 
> if (is_mmio_spte(spte))
>     handle_mmio
> if (spte == spte_not_present) /* race, let CPU refault */
>     return
> handle EPT misconf
> 

The patch already did it as you say :p

if (is_mmio_spte(spte))
	return handle_mmio
if (spte_present(spte))
	return handle EPT misconfig

return page fault path /*I will fix it, let cpu refault instead*/

