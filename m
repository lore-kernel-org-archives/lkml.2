Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab2KEOtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:49:04 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:56488 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606Ab2KEOtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:49:02 -0500
Date: Mon, 5 Nov 2012 14:49:00 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/9] rcu: use __this_cpu_read helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
In-Reply-To: <509645A5.5070901@gmail.com>
Message-ID: <0000013ad10bc571-9f707c9b-14e3-4382-a472-2a1aaa3fb384-000000@email.amazonses.com>
References: <5093EE6B.3070906@gmail.com> <20121102181026.GY3027@linux.vnet.ibm.com> <0000013ac2c6e1f0-c10ec42d-70bb-4e24-99d6-8e70653eca83-000000@email.amazonses.com> <20121103091909.GI3027@linux.vnet.ibm.com> <509645A5.5070901@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2012, Shan Wei wrote:

>  __this_cpu_read<-----------------2
> 0000000000000000 <init_module>:
>    0:   55                      push   %rbp
>    1:   31 c0                   xor    %eax,%eax
>    3:   48 89 e5                mov    %rsp,%rbp
>    6:   48 83 ec 10             sub    $0x10,%rsp
>    a:   c9                      leaveq
>    b:   c3                      retq

?? There should be an operation using gs: here. This does not look
like code that includes a __this_cpu_read().

