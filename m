Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab2INMze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:55:34 -0400
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:40093 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754707Ab2INMza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:55:30 -0400
Message-ID: <50532940.10201@akamai.com>
Date: Fri, 14 Sep 2012 07:55:28 -0500
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
References: <20120912085140.GA12277@aftab.osrc.amd.com> <5050824B.9050006@akamai.com> <5050857F.5060207@akamai.com> <20120912153016.GA12103@aftab.osrc.amd.com> <5050AC2E.3050408@akamai.com> <20120912154943.GB12103@aftab.osrc.amd.com> <5050B708.5020308@akamai.com> <20120912164843.GC12103@aftab.osrc.amd.com> <5050BF1F.1080503@akamai.com> <20120912170629.GD12103@aftab.osrc.amd.com> <20120912172351.GE12103@aftab.osrc.amd.com>
In-Reply-To: <20120912172351.GE12103@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 12:23 PM, Borislav Petkov wrote:
> Ok, I have something preliminary which seems to work fine on my K8 here.
> If you'd like, you can give it a run:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git error-queue
>
> I've changed also debug messages, etc, so pls take a look at those and
> let me know whether they're understandable, make sense, etc, etc.

Boris

Thanks to your help I was able to test your branch, but it still does 
not resolve the problem. Removal of the "factor=1" workaround fixes the 
memory size reporting on boot, but the sysfs values are still incorrect.

[   25.836264] EDAC MC: DCT0 chip selects:
[   25.836266] EDAC amd64: MC: 0:  1024MB 1:  1024MB
[   25.836398] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   25.836530] EDAC amd64: MC: 4:     0MB 5:     0MB
[   25.836662] EDAC amd64: MC: 6:     0MB 7:     0MB

root@192.168.1.1:/sys/devices/system/edac/mc/mc0# grep . *
ce_count:0
ce_noinfo_count:0
dbam:0x0000000000000022
dhar:0x00000000ee001201
dram_hole:ee000000 12000000 12000000
max_location:csrow 7 channel 1
mc_name:K8
grep: reset_counters: Permission denied
sdram_scrub_rate:761
seconds_since_reset:276
size_mb:8192
topmem:0x00000000ee000000
topmem2:0x0000000112000000
ue_count:0
ue_noinfo_count:0

root@192.168.1.1:/sys/devices/system/edac/mc/mc0/csrow1# grep . *
ce_count:0
ch0_ce_count:0
ch0_dimm_label:mc#0csrow#0channel#1
ch1_ce_count:0
ch1_dimm_label:mc#0csrow#4channel#1
dev_type:Unknown
edac_mode:S4ECD4ED
mem_type:Unbuffered-DDR2
size_mb:2048
ue_count:0

To be sure I'm using the correct branch the last git log entry is:
9d67117feece8852570cc8ee25b68c41f8def323

I could be incorrect, but I still think there's a problem with either a) 
ddr2_cs_size() for this cpu, or b) the extra shift left when WIDTH_128 
is true.

Josh
