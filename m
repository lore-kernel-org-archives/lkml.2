Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab2HCQqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:46:38 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:54283 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432Ab2HCQqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:46:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120803104212.GA6936@x1.osrc.amd.com>
References: <1343985378-22330-1-git-send-email-vikram.pandita@ti.com>
 <D958900912E20642BCBC71664EFECE3E6DDCAC49AB@BGMAIL02.nvidia.com>
 <D958900912E20642BCBC71664EFECE3E6DDCAC49AE@BGMAIL02.nvidia.com>
 <CAFm5wm2Z+FyVqG5oMWiEmZ8Je88hJ-cyDXmJw0wp4mqA-X9eYg@mail.gmail.com>
 <CAPXgP13UBwQLs+m_aSk3Ljbktz8WrL+ZO_Tfhrt_+tRBCARyQQ@mail.gmail.com>
 <CAFm5wm0nf47bcTu7iiXA3geR_5dDTF1tnf81Lz7JzbWkKdhUtA@mail.gmail.com>
 <CAPXgP11A=QfOt4SL2GvhsepP8JiDFfdaAhi6-AhW++-AvOz+aw@mail.gmail.com> <20120803104212.GA6936@x1.osrc.amd.com>
From: "Pandita, Vikram" <vikram.pandita@ti.com>
Date: Fri, 3 Aug 2012 09:46:15 -0700
Message-ID: <CAFm5wm0rsvuBafMH+9PpKwfaBimbRrVzxYV0nD_pg1yisAYwxQ@mail.gmail.com>
Subject: Re: [PATCH v2] printk: add option to print cpu id
To: Borislav Petkov <bp@alien8.de>, Kay Sievers <kay@vrfy.org>
Cc: linux-omap <linux-omap@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav/Kay

On Fri, Aug 3, 2012 at 3:42 AM, Borislav Petkov <bp@alien8.de> wrote:
>
> On Fri, Aug 03, 2012 at 12:09:15PM +0200, Kay Sievers wrote:
> > That would be needed, I guess. We easily have server systems with more
> > than 255 CPUs. It will only be a matter of time, that the number of
> > CPUs will increase for everybody, I guess.
>
> Actually, AFAICR, we already have SGI machines booting Linux on 4K cpus.
> Now.
>
> > > b) to put cpuid in struct cont and struct log - under the #ifdef
> > > macro?
> >
> > As said, I really can't tell how generally useful it is, and if people
> > think that it should be there unconditionally, should not be there at
> > all, or as a compile time option. Others might have an opinion on
> > that.
> >
> > I personally never missed the CPU-ID in the logs. I personally would
> > find the PID/task ID more interesting, and even that I never really
> > missed. :)

I mostly work with ARM Soc - specifically on OMAP.
SMP multi core systems in ARM-v7 world started to show up only few
years back - unlike x86 world.

ARM systems are a bit unique when it comes to security( read trust
zone ), and handling of FIQ's.
Most of the ARM cortex-A series SoC's out there have some kind of
affinity to CPU0 being the master.
One use case has been, it has helped to know with this printk logging,
if such constraints are honored.

Sometimes, tracking of some lockup cases between cpu's because of bad
code has also been helpful with this logging support.
For now i will post v3 of the patch and add arm-list and linux-omap
list, and there might be users there can benefit.

>
> And even then you can add debugging code to dump the stuff you need.
>
> And I have to agree with Kai here, having the cpu number in dmesg is
> not something I'd wish for - printk timestampts OTOH has at least some
> usecases.
>
> Thanks.
>
> --
> Regards/Gruss,
> Boris.
