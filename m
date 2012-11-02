Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab2KBRtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:49:16 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:10071 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932213Ab2KBRtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:49:13 -0400
Date: Fri, 2 Nov 2012 17:49:12 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: David Miller <davem@davemloft.net>, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9 v2] use efficient this_cpu_* helper
In-Reply-To: <5093EEC2.7000109@gmail.com>
Message-ID: <0000013ac23daa38-76df0db5-322e-4df6-bcb8-0be356eb8846-000000@email.amazonses.com>
References: <5093EEC2.7000109@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="288502408-1248043375-1351878512=:7937"
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--288502408-1248043375-1351878512=:7937
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sat, 3 Nov 2012, Shan Wei wrote:

> this_cpu_ptr is faster than per_cpu_ptr(p, smp_processor_id())
> and can reduce  memory accesses.
> The latter helper needs to find the offset for current cpu,
> and needs more assembler instructions which objdump shows in following.
>
> per_cpu_ptr(p, smp_processor_id())：
>   1e:   65 8b 04 25 00 00 00 00         mov    %gs:0x0,%eax
>   26:   48 98                           cltq
>   28:   31 f6                           xor    %esi,%esi
>   2a:   48 c7 c7 00 00 00 00            mov    $0x0,%rdi
>   31:   48 8b 04 c5 00 00 00 00         mov    0x0(,%rax,8),%rax
>   39:   c7 44 10 04 14 00 00 00         movl   $0x14,0x4(%rax,%rdx,1)
>
> this_cpu_ptr(p)
>   1e:   65 48 03 14 25 00 00 00 00      add    %gs:0x0,%rdx
>   27:   31 f6                           xor    %esi,%esi
>   29:   c7 42 04 14 00 00 00            movl   $0x14,0x4(%rdx)
>   30:   48 c7 c7 00 00 00 00            mov    $0x0,%rdi

this_cpu_read() etc even avoids the use of this_cpu_ptr()
reducing the 6 instructions earlier to 1.
--288502408-1248043375-1351878512=:7937--
