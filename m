Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934950Ab1ETOfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:35:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58519 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933843Ab1ETOfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IKzRJrw2ipot7xLOCIsj4A65W0SJc6D7tZxGTOTqKb3YhxxbyKBJehz1xUky435jep
         aNiyP6ig8vKnTUZLBIOVG6DdAnVOz+8VHSZ3dLNsFsqMv9hgL7vnWHyDOge4Lrk6q2hX
         ukNN/cIvsNznjlFOM2eTLOzEl/2nr68R+MjYs=
Message-ID: <4DD67C15.7040601@openvz.org>
Date: Fri, 20 May 2011 18:35:01 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] x86, apic: use .apicdrivers section to find the list
 of apic drivers
References: <20110519234545.700125442@sbsiddha-MOBL3.sc.intel.com> <20110519234637.671736436@sbsiddha-MOBL3.sc.intel.com>
In-Reply-To: <20110519234637.671736436@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2011 03:45 AM, Suresh Siddha wrote:
> This will enable each apic driver to be self-contained and eliminate the need
> for apic_probe[].
> 
> Apic probe will now depend on the order in which apic drivers are listed in
> the .apicdrivers section. Ordering of apic driver files in the Makefile
> and the macros apic_driver()/apic_drivers() help enforce the desired order.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
...
> Index: linux-2.6-tip/arch/x86/kernel/vmlinux.lds.S
> ===================================================================
> --- linux-2.6-tip.orig/arch/x86/kernel/vmlinux.lds.S
> +++ linux-2.6-tip/arch/x86/kernel/vmlinux.lds.S
> @@ -305,6 +305,12 @@ SECTIONS
>  		__iommu_table_end = .;
>  	}
>  

Seems we miss ALIGN here, no?

	. = ALIGN(8);

> +	.apicdrivers : AT(ADDR(.apicdrivers) - LOAD_OFFSET) {
> +		__apicdrivers = .;
> +		*(.apicdrivers);
> +		__apicdrivers_end = .;
> +	}
> +
...
-- 
    Cyrill
