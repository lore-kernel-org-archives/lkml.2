Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab2KGMGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 07:06:01 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39365 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab2KGMGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 07:06:00 -0500
MIME-Version: 1.0
In-Reply-To: <20121105183509.GA1254@beefymiracle.amer.corp.natinst.com>
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
	<20121024200310.GB6713@beefymiracle.amer.corp.natinst.com>
	<0d1c4cf8-70d8-4d12-bd77-393009d32b22@CH1EHSMHS001.ehs.local>
	<20121027140053.GB5190@beefymiracle.amer.corp.natinst.com>
	<4fd22fac-49c4-4000-9e70-12e94f248753@AM1EHSMHS010.ehs.local>
	<20121027144253.GC5190@beefymiracle.amer.corp.natinst.com>
	<60e4cbf9-52b4-4c02-8537-ecd3a7dbbf06@CO1EHSMHS020.ehs.local>
	<20121105183509.GA1254@beefymiracle.amer.corp.natinst.com>
Date: Wed, 7 Nov 2012 13:05:57 +0100
X-Google-Sender-Auth: 4gs_gtBgfNJbp4zbwh6DKkpx6ZM
Message-ID: <CAHTX3dLgWxCzLT=TH+7ydep-m4+euVCP2cBo=Yx1qhe4xVL7NA@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] zynq: use GIC device tree bindings
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/5 Josh Cartwright <josh.cartwright@ni.com>:
> On Sat, Oct 27, 2012 at 03:20:59PM +0000, Michal Simek wrote:
>> On Saturday, October 27, 2012 4:43 PM, Josh Cartwright wrote:
>> > On Sat, Oct 27, 2012 at 02:06:45PM +0000, Michal Simek wrote:
>> > [...]
>> > > I am not big fan to use dtsi solution because dts can be simple
>> > > generated directly From Xilinx design tool based on your hw design.
>> > > That's why I can't see any benefit To have dtsi file.
>> >
>> > Can I ask you to reconsider?
>>
>> I am open to all solution which will help others. I am not definitely
>> saying NO for this features I just haven't found a reason to support
>> it.
>>
>> > We, for example, don't make any use of the Xilinx
>> > dev tools to generate our device trees.
>>
>> Ok. How does your working flow looks like?  I mean you don't get any
>> information from hardware guys how does your hw design look like?
>
> Our usecase may admittedly be a bit weird, because what logic is in the
> PL is ultimately determined (and even implemented) by the end user and
> is loaded at runtime.  There is a lot of machinery to make that happen,
> but the point is that I don't have sufficient knowledge upfront to
> generate appropriate bindings for what's in the PL.

ok. It means that you need to use just the part of DTS without PL logic at all.
Does it mean that PL will be connected with any DTS fragment?



>> > Having a dtsi allows for easy extension of the zynq-7000 platform
>> > for our boards, without having to carry duplicate data.
>>
>> ok. I think that make sense if you send the next your series as RFC to
>> see how exactly you would like to use it.
>
> It seems like you caught a glimpse of this in my COMMON_CLK patchset. :)

Yes. Just need to get some time to analyze it.


>> In my workflow we generate DTS directly from design tool which I
>> expect your hw guys use because it is probably needed to generate
>> boot.bin/fsbl/etc.  Then there is one more additional step to setup
>> device-tree bsp to generate DTS which directly fits to your HW design.
>> If you have the same boards with different programmable logic I
>> understand that you would like to share that PS part and then just add
>> it that IPs in PL.
> [..]
>> From my point of view. You have to use design tools at least once to
>> get bitstream and boot.bin with fsbl. Please correct me if I am wrong.
>> In this step you can use device-tree BSP to generate DTS ( I doesn't
>> need to be perfect with all attached devices on i2c,spi, phys, etc but
>> it reflects your hardware).  You will get it in some seconds and your
>> dts has correct irq numbers/ip description, compatible strings,
>> addresses, position in the system - if you use bus bridges, etc) and
>> you can just directly use it and kernel will boot. If you need to do
>> changes in dts by hand, you can of course do it.
>
> I wouldn't be as opposed to device tree generation if the device tree
> generator was in tree.

Which tree do you exactly mean? Linux kernel or just any git tree?

Let me give you more information about the generator. It uses TCL in SDK
where it provides all structure from the system. It means device-tree generator
will read all information from design tool and based on that will generate
DTS file. It also means if user will setup specific irq lines in design, special
paramters setting in registers then all these values will be added to DTS.
.

> Device tree bindings change, how would/could an
> out-of-tree generator possibly handle changes in bindings?

What do you mean by that? Any example?
Generator will generate DTS on the current configuration which you have setup
in EDK.
For your case when you generate PL part at runtime you probably will use
just the part of DTS (that hard IPs)


>  Would a user
> target the generator at a specific version of the kernel?  (An in tree
> generator would also seem to necessitate a more formal specification
> language for DT bindings).

Device tree description in the hardware description which is not changing
across kernel versions. Xilinx device tree generator generates DTS
which reflects all standards.
We can send the generated output to device-tree mainling list and ask
for review.

For clk common patches this features is not implemented yet but it is easy
to add it and all generated DTSes will contains it.
If you think to label generator with specific version then we can use
any tag in the device-tree BSP tree.


> It is odd to me that the use of a generator would be required to create
> what is completely static data.  What I'm referring to here is the
> collection of peripherals on the zynq-7000 that are not in the PL.  For
> me, this requirement adds an unnecessary dependency on the Xilinx EDK
> that I would like to avoid.

I am not saying that you need to use it. If you want to write your DTS
by hand, you still can
but I expect that the most of zynq users will use generator and
generate it because
it is just easier than to describe it by hand and they can be sure
that all parameters are
correctly generated.
If you are using any non-standard solution where you will load pl
logic at runtime
then you can use just generated DTS for hardblock or write it by hand.


> Would it make sense to limit what the device tree generator produces to
> only what is in the PL?  (Forgive my ignorance about this tool, I've
> never used it.)

It is tcl script everything is possible.
Are you interesting to use it just for PL?

> This could just be an extension of what I've started to do with the
> COMMON_CLK patchset.  A zynq board would be described using several
> device tree snippets, one for the baked-in zynq-7000 peripheral set, one
> for a generated description of what is in the PL, and one describing any
> board-specific details (phy, etc).  Something like below:
>
> zynq-7000.dtsi  : description of static zynq-7000 peripherals
>
>         / {
>                 amba : amba@0 {
>                         slcr: slcr@f8000000 {
>                                 clocks {
>                                         ps_clk : ps_clk {
>                                                 compatible = "fixed-clock";
>                                         };
>                                         ...
>                                 }
>                         };
>                         i2c0 : i2c0@e0004000 {
>                                 compatible = "xlnx,i2cps";
>                                 ...
>                         };
>                         eth0 : eth0@e000b000 {
>                                 compatible = "xlnx,emacps";
>                                 ...
>                         };
>                 };
>         };
>
> zynq-zc702-pl.dtsi : generated description of what is in the PL
>
>         &amba {
>                 /* PL IP generated descriptions here. */
>         };
>
> zynq-zc702.dts  : board-specific descriptions (osc freq, i2c, spi, phys, etc)
>
>         /include/ "zynq-7000.dtsi"
>         /include/ "zynq-zc702-pl.dtsi"
>         &ps_clk {
>                 clock-frequency = <33333330>;
>         };
>         &i2c0 {
>                 pca9548@74 {
>                         ...
>                         reg = <0x74>;
>                         ...
>                 };
>         };
>         &eth0 {
>                 phy@7 {
>                         compatible = "marvell,888e1116r";
>                         ...
>                         reg = <0x7>;
>                 };
>         };
>
> Thoughts?


The problem which I have with it is that if we accept this solution then
we will have to use 3(4-because of skeleton.dtsi) files where 2 files will fix
the origin model.
I can't see the reason why not to use just one file which will
describe it directly.

If you want to use solution with several dtsi files and compose it as
you describe
then it is completely fine but forcing others to use this structure
and write dts by hand will be big pain for a lot of users.

Also in design tools you can setup if you use qspi,nor,nand flash
memory interface.
memory interface, baudrates, dma, ports to PL logic, connections, etc.
and from my point of view is very complicated to describe it by

There are a lot of combination which you can have on one reference board.
You can't enable all hard IPs at one time and use all of them that's
why you shouldn't
list all of them in the kernel.

>From my point of view make sense to have one DTS file in the kernel
and one defconfig
for the most popular zynq board where will be exactly written that this DTS is
connected to this reference hw design. If you want to get more reference design
go to this page and download it.
Adding all DTSes for zynq boards to the kernel is overkill.
If you want to use your hw design you can use this generator and
generate it or write it by
hand.

Thanks,
Michal
