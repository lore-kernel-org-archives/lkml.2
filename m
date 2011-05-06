Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab1EFK4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:56:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:56710 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403Ab1EFK42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:56:28 -0400
Message-ID: <4DC3D3D5.6060007@suse.cz>
Date: Fri, 06 May 2011 12:56:21 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/6] of: Allow scripts/dtc/libfdt to be used from
 kernel code
References: <1304614949-30460-1-git-send-email-ddaney@caviumnetworks.com> <1304614949-30460-2-git-send-email-ddaney@caviumnetworks.com>
In-Reply-To: <1304614949-30460-2-git-send-email-ddaney@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.5.2011 19:02, David Daney wrote:
> --- /dev/null
> +++ b/drivers/of/libfdt/Makefile
> @@ -0,0 +1,8 @@
> +ccflags-y := -include linux/libfdt_env.h -I$(src)/../../../scripts/dtc/libfdt
> +
> +obj-y = fdt.o fdt_wip.o fdt_ro.o
> +
> +
> +$(obj)/%.o: $(src)/../../../scripts/dtc/libfdt/%.c FORCE
> +	$(call cmd,force_checksrc)
> +	$(call if_changed_rule,cc_o_c)

It's just three source files, so you could use three one-line wrappers 
that #include ../../../scripts/dtc/libfdt/<file>.c instead of copying 
the %.c -> %.o rule here.

Michal
