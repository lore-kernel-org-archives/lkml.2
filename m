Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab2IRBfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 21:35:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34478 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab2IRBfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 21:35:18 -0400
X-IronPort-AV: E=Sophos;i="4.80,440,1344182400"; 
   d="scan'208";a="5860784"
Message-ID: <5057D123.7040109@cn.fujitsu.com>
Date: Tue, 18 Sep 2012 09:40:51 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: section mismatch for acpi_unmap_lsapic()
References: <20120914163809.GA6854@cantor.us.oracle.com> <20120917110729.GA1018@gmail.com>
In-Reply-To: <20120917110729.GA1018@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/18 09:35:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/18 09:35:34,
	Serialize complete at 2012/09/18 09:35:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 09/17/2012 07:07 PM, Ingo Molnar Wrote:
> 
> * Jerry Snitselaar <dev@snitselaar.org> wrote:
> 
>> Commit 13ad20c1 "x86 cpu_hotplug: unmap cpu2node when the cpu is
>> hotremoved" in linux-next added code to acpi_unmap_lsapic() that
>> causes section mismatch warnings:
>>
>> WARNING: vmlinux.o(.text+0x694f2): Section mismatch in reference from the function acpi_unmap_lsapic()
>> 	  to the function .cpuinit.text:numa_clear_node()
>> WARNING: vmlinux.o(.text+0x694eb): Section mismatch in reference from the function acpi_unmap_lsapic() 
>> 	  to the variable .cpuinit.data:__apicid_to_node
>>
>>
>> Does acpi_unmap_lsapic() need a wrapper like the one that was made for
>> acpi_map_lsapic() or can it just be annotated __ref ? I guess my
>> question is would be there be a reason that the wrapper was created
>> for acpi_map_lsapic() instead of just annotating __ref besides
>> allowing the code for _apic_map_lsapic() to be dropped when
>> HOTPLUG_CPU wasn't configured?
> 
> That commit comes from -mm AFAICS. Involved parties Cc:-ed.

Sorry for introducing this warning. numa_clear_node() is in cpuinit
section, and it will be called in acpi_unmap_lsapic(), so I agree
to add __ref to this function. Should I need to post another patch
to fix it or just update the patch?

Thanks
Wen Congyang

> 
> Thanks,
> 
> 	Ingo
> 

