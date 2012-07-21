Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab2GUKts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 06:49:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47426 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2GUKtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 06:49:46 -0400
Message-ID: <500A8969.1040300@gmail.com>
Date: Sat, 21 Jul 2012 12:50:17 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120713 Thunderbird/13.0
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v7] kvm: notify host when the guest is panicked
References: <500A565A.8080403@cn.fujitsu.com>
In-Reply-To: <500A565A.8080403@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2012 09:12 AM, Wen Congyang wrote:
> +#define KVM_PV_PORT	(0x505UL)
> +
>  #ifdef __KERNEL__
>  #include <asm/processor.h>
>  
> @@ -221,6 +223,11 @@ static inline void kvm_disable_steal_time(void)
>  }
>  #endif
>  
> +static inline unsigned int kvm_arch_pv_features(void)
> +{
> +	return inl(KVM_PV_PORT);
> +}
> +

Why is this safe?

I'm not sure you can just pick any ioport you'd like and use it.
