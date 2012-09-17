Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab2IQLHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:07:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40556 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab2IQLHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:07:35 -0400
Date: Mon, 17 Sep 2012 13:07:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: section mismatch for acpi_unmap_lsapic()
Message-ID: <20120917110729.GA1018@gmail.com>
References: <20120914163809.GA6854@cantor.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914163809.GA6854@cantor.us.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jerry Snitselaar <dev@snitselaar.org> wrote:

> Commit 13ad20c1 "x86 cpu_hotplug: unmap cpu2node when the cpu is
> hotremoved" in linux-next added code to acpi_unmap_lsapic() that
> causes section mismatch warnings:
> 
> WARNING: vmlinux.o(.text+0x694f2): Section mismatch in reference from the function acpi_unmap_lsapic()
> 	  to the function .cpuinit.text:numa_clear_node()
> WARNING: vmlinux.o(.text+0x694eb): Section mismatch in reference from the function acpi_unmap_lsapic() 
> 	  to the variable .cpuinit.data:__apicid_to_node
> 
> 
> Does acpi_unmap_lsapic() need a wrapper like the one that was made for
> acpi_map_lsapic() or can it just be annotated __ref ? I guess my
> question is would be there be a reason that the wrapper was created
> for acpi_map_lsapic() instead of just annotating __ref besides
> allowing the code for _apic_map_lsapic() to be dropped when
> HOTPLUG_CPU wasn't configured?

That commit comes from -mm AFAICS. Involved parties Cc:-ed.

Thanks,

	Ingo
