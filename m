Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab1BNQTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:19:04 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53723 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab1BNQTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:19:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=yBuFVwhV3SO6GRKlH3C/wsMZVXmRCnFdPvC+F7WnWlGc7m+rgUh+OT2ZHGcvxVIzr/
         2M3e5JAs+uxUsXAPQ5sgXpPQP04ppbeQcRxRp5iwgpYadp6+ebWo1NdIAC7iKgBJBJ6K
         +wAoZZ0cWAywypjlS4LHCmwW0AB06F2guBlR0=
Date: Mon, 14 Feb 2011 17:18:57 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 04/26] x86-64, NUMA: Unify
 {acpi|amd}_{numa_init|scan_nodes}() arguments and return values
Message-ID: <20110214161857.GW18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
 <1297530663-26234-5-git-send-email-tj@kernel.org>
 <4D56D3C7.8050803@kernel.org>
 <20110214112931.GF18742@htj.dyndns.org>
 <AANLkTi==t7SfjuLUoXmLawNL-jVqb8r3R7rOzjkjQh_Z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi==t7SfjuLUoXmLawNL-jVqb8r3R7rOzjkjQh_Z@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 08:14:36AM -0800, Yinghai Lu wrote:
> when system have acpi support  but SRAT is NOT there,  new
> acpi_numa_init() will return 0 just like SRAT is there and correct.
> So it will skip AMD node scanning.

How does it return 0?

...
		cnt = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
					    acpi_parse_memory_affinity,
					    NR_NODE_MEMBLKS);
If there's no srat, cnt is zero.
	}

	/* SLIT: System Locality Information Table */
	acpi_table_parse(ACPI_SIG_SLIT, acpi_parse_slit);

	acpi_numa_arch_fixup();

	if (cnt <= 0)
if cnt is zero, the if is taken
		return cnt ?: -ENOENT;
and as cnt is zero, -ENOENT is returned.
	return 0;
The function returns 0 iff cnt > 0.

-- 
tejun
