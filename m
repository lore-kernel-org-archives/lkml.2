Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab0DGPsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:48:32 -0400
Received: from web114307.mail.gq1.yahoo.com ([98.136.183.37]:41860 "HELO
	web114307.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932662Ab0DGPsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:48:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=OZeJD9Z9lebTk2h71uBeWNAfGMufb3toaKpEMQgUSvX3Spsb81FxmjB1N2ovQBMjU6ifVr81v41+Cv+jvNtSuDoLNLX7LIygdcQlfj7b1ywJcIEDh0phkS0UJZutA/Qdu5UuPoxaHAt7CE2F+hFKoz6wHI6D7IKR63OPxf1555E=;
Message-ID: <190529.78750.qm@web114307.mail.gq1.yahoo.com>
X-YMail-OSG: 70Uk6cYVM1l1muDGk6IVb8DURAIF5g5xdp5fr6Im_LuimUt
 HgFucFwprsKeVyUJxxmtEYO6bz61SHtuRK56MQa9LhTuMKber6xbPGknbKEK
 QaWxfzEaPMOX2wXW0k6n5uN9TF8kGWJhEzhQNucmhMv4oDVUCuLls_hkKsiR
 GSbEt9NiOkKzu1IRsU69jcRYl4tHf_Ub.kr5_ZmDsurFxNmb9FVLirR9WFT1
 AvmBjgLMybxfQtlAx6X1vy_tze_bXQyv_63QPR_lzF51bVcVEGP.lqF_E2cJ
 CqZ1zR5AamqtjR6QbZhit_Q--
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Wed, 7 Apr 2010 08:48:30 -0700 (PDT)
From: Rick Sherm <rick.sherm@yahoo.com>
Subject: Re: Memory policy question for NUMA arch....
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-numa@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100407090014.GD18855@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

--- On Wed, 4/7/10, Andi Kleen <andi@firstfloor.org> wrote:
> On Tue, Apr 06, 2010 at 01:46:44PM -0700, Rick Sherm wrote:
> > On a NUMA host, if a driver calls __get_free_pages()
> then 
> > it will eventually invoke
> ->alloc_pages_current(..). The comment 
> > above/within alloc_pages_current() says
> 'current->mempolicy' will be 
> > used.So what memory policy will kick-in if the driver
> is trying to 
> > allocate some memory blocks during driver load
> time(say from probe_one)? System-wide default
> policy,correct?
> 
> Actually the policy of the modprobe or the kernel boot up
> if built in
> (which is interleaving)
> 

Interleaving,yup that's what I thought. I've tight control on the environment.So for one driver I need high throughput and I will use the interleaving-policy.But for the other 2-3 drivers, I need low latency.So I would like to restrict it to the local node.These are just my thoughts but I'll have to experiment and see what the numbers look like. Once I've some numbers I will post them in a few weeks.

> > 
> > What if the driver wishes to i) stay confined to a
> 'cpulist' OR ii) use a different mem-policy? How 
> > do I achieve this?
> > I will choose the 'cpulist' after I am successfuly
> able to affinitize the MSI-X vectors.
> 
> You can do that right now by running numactl ... modprobe
> ...
> 
Perfect.Ok, then I'll probably write a simple user-space wrapper:
  1)set mem-policy type depending on driver-foo-M.
  2)load driver-foo-M.
  3)goto 1) and repeat for other driver[s]-foo-X
BTW - I would know before hand which adapter is placed in which slot and so I will be able to deduce its proximity to a Node.

> Yes there should be probably a better way, like using a
> policy
> based on the affinity of the PCI device.
> 

> -Andi
> 

Thanks
Rick


      
