Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab0HCIcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:32:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:33960 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab0HCIcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:32:53 -0400
Subject: Re: [PATCH RFC 10/12] x86/pvticketlock: keep count of blocked cpus
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>
In-Reply-To: <9d5625e61c7f35e72156e8cb881e55910b4fa5dc.1279328276.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com>
	 <9d5625e61c7f35e72156e8cb881e55910b4fa5dc.1279328276.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 03 Aug 2010 10:32:40 +0200
Message-ID: <1280824360.1923.421.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-16 at 18:03 -0700, Jeremy Fitzhardinge wrote:
> @@ -26,6 +26,9 @@ typedef struct arch_spinlock {
>                         __ticket_t head, tail;
>                 } tickets;
>         };
> +#ifdef CONFIG_PARAVIRT_SPINLOCKS
> +       __ticket_t waiting;
> +#endif
>  } arch_spinlock_t; 

This bloats spinlock_t from u32 to u64 on most distro configs I think,
since they'll have NR_CPUS=4096 or something large like that and
probably also want to have this PARAVIRT_SPINLOCKS thing.
