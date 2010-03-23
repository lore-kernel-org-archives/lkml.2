Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab0CWWgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 18:36:43 -0400
Received: from p01c11o147.mxlogic.net ([208.65.144.70]:51130 "EHLO
	p01c11o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab0CWWgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 18:36:42 -0400
X-MXL-Hash: 4ba9427a7b316f54-d448b508f715b7c2250f54b21937b3d180df9976
X-MXL-Hash: 4ba942710491a35d-dd4d23028c09e454a6be7ff527737b92a6e5798a
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ryan Mallon <ryan@bluewatersys.com>
CC: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Date: Tue, 23 Mar 2010 17:35:25 -0500
Subject: RE: [PATCH 0/2] arm: add a /proc/cpuinfo platform extension
Thread-Topic: [PATCH 0/2] arm: add a /proc/cpuinfo platform extension
Thread-Index: AcrK1GK9H4hSU7atSai2XYiVqrt1hwAAkhTQ
Message-ID: <0D753D10438DA54287A00B02708426976368E58719@AUSP01VMBX24.collaborationhost.net>
References: <BD79186B4FD85F4B8E60E381CAEE19090200F377@mi8nycmail19.Mi8.com>
 <4BA924CD.1010201@bluewatersys.com>
 <0D753D10438DA54287A00B02708426976368E58561@AUSP01VMBX24.collaborationhost.net>
 <4BA93A43.2010807@bluewatersys.com>
In-Reply-To: <4BA93A43.2010807@bluewatersys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010031801)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.99]
X-AnalysisOut: [v=1.0 c=1 a=ivgDoJX_mgAA:10 a=VphdPIyG4kEA:10 a=8nJEP1OIZ-]
X-AnalysisOut: [IA:10 a=MfCJKx98tC58LqYwCYfhJw==:17 a=i00gxMtYAAAA:8 a=Jfr]
X-AnalysisOut: [nYn6hAAAA:8 a=3IbmYkmgVggBgOpUV0sA:9 a=kYPORX13eSVnrSqhhig]
X-AnalysisOut: [A:7 a=Ba88S1HeCbmzvsKETNhOCXnMeHEA:4 a=wPNLvfGTeEIA:10 a=x]
X-AnalysisOut: [1WnkoZAwusA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 23, 2010 3:02 PM, Ryan Mallon wrote:
> H Hartley Sweeten wrote:
>> On Tuesday, March 23, 2010 1:30 PM, Ryan Mallon wrote:
>>> H Hartley Sweeten wrote:
>>>> Add an optional platform specific extension to /proc/cpuinfo.
>>>>
>>>> Many platforms have custom cpu information that could be exposed
>>>> to user space using /proc/cpuinfo.
>>>>
>>>> Patch 1/2 adds the necessary core support to allow a platform
>>>> specific callback to dump this information.
>>>>
>>>> Patch 2/2 adds a callback to mach-ep93xx and hooks up all the
>>>> edb93xx platforms.
>>>>
>>>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>>>>
>>>> _______________________________________________
>>>> linux-arm-kernel mailing list
>>>> linux-arm-kernel@lists.infradead.org
>>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>> I think this is unlikely to get merged in its current state. Russell has
>>> mentioned issues with breaking userspace by changing /proc/cpuinfo. 
>> 
>> I don't agree with this point.
>> 
>
> [snip]
>
>> 
>> Even something as trivial as the BogoMIPS is in a different place in
>> the two outputs and is spelled differently (due to caps).
>> 
>> The outputs are completely different.  Other architectures in
>> mainline also have very different outputs.
>> 
>> I can't see any reason why adding additional fields will break
>> user space, as long as an existing heading in the output is not
>> duplicated.  Even that "really" shouldn't break anything since
>> any application parsing this file has to do it sequentially and
>> the new headings are located at the end of the file.
>
> I'm really not sure. There may be some crappy userspace tools out there
> which will break. I don't really mind either way if the info goes in
> /proc/cpuinfo, or some new /proc/archinfo, just as long as it doesn't
> break userspace in some way.

I did a grep of glibc's source (cvs-2.9, the only one currently on my
system) to see what it tries to parse out of /proc/cpuinfo.  These are
the only ones I could find:

./sysdeps/unix/sysv/linux/arm/ioperm.c
	"Hardware\t: %256[^\n]\n"
./sysdeps/unix/sysv/linux/m68k/getsysstats.c
	"CPU:"
./sysdeps/unix/sysv/linux/mips/getsysstats.c
	"cpu model"
./nptl/perf.c
	"cpu MHz"
./nptl/sockperf.c
	"cpu MHz"
./sysdeps/unix/sysv/linux/getsysstats.c
	"processor"
./sysdeps/unix/sysv/linux/alpha/getsysstats.c
	"cpus active : %d"
	"CPUs probed %*d active %d"
	"cpus detected : %d"
	"CPUs probed %d"
./sysdeps/unix/sysv/linux/alpha/ioperm.c
	"system type : %256[^\n]\n"
	"system variation : %256[^\n]\n"
	"cpu model :%256[^\n]\n"
./sysdeps/unix/sysv/linux/i386/get_clockfreq.c
	"cpu MHz"
./sysdeps/unix/sysv/linux/ia64/get_clockfreq.c
	"itc MHz"
./sysdeps/unix/sysv/linux/powerpc/get_clockfreq.c
	"timebase"
./sysdeps/unix/sysv/linux/sparc/getsysstats.c
	"ncpus active : %d"
	"ncpus probed : %d"
./sysdeps/unix/sysv/linux/sparc/sparc64/get_clockfreq.c
	"Cpu0ClkTck"

There may be other userspace tools out there that look at this file
but I would assume they still would parse it using fopen/sscanf/fclose.
Nothing should break as long as the new data is at the end of the file.

>>> The other problem I see is that you have a single callback for registering
>>> the arch specific information. In you ep93xx example, each of the ep93xx
>>> boards must add:
>>>
>>>  .arch_cpuinfo = ep93xx_cpuinfo,
>>>
>>> If one of the boards has some additional information to make available,
>>> it would need to reimplement the entire callback, which gets messy.
>> 
>> Not necessarily.
>> 
>> If a board, such as the ts72xx, wanted to add additional information
>> it just has to register it's private callback then call the ep93xx core
>> supplied callback at the desired point in it's private one.
>> 
>> The ts72xx currently does this exact thing with the .map_io callback.
>> It supplies it's own private one to map the external FPGA.  It first calls
>> the ep93xx core to map the ahb/apb space then it does an iotable_init to
>> map the FPGA.
>
> Okay, fair point. I still don't like having the seq_file callback being
> in machine_desc. It means that all of the board files have to be edited
> to add the callback. It should be something which happens automagically
> in the platform core. Perhaps using a weak function for the callback, or
> a #define check.

The callback is copied from the machine_desc in arch/arm/kernel/setup.c
just like the other architecture-specific pointers.  If an architecture
does not have any additional data to dump they don't have to provide the
callback.  If it's not provided, the main seq_file callback (c_show in
arch/arm/kernel/setup.c) will not call it.  See Patch 1/3 of the series.

Regards,
Hartley