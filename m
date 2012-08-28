Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab2H1OhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 10:37:24 -0400
Received: from m50-134.163.com ([123.125.50.134]:34247 "EHLO m50-134.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab2H1OhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 10:37:22 -0400
References: <CA+HMz3jBzbmgSANr8M4wwKD-SbVPrnsMdXqKnN+sa+S79r=P1w@mail.gmail.com>
In-Reply-To: <CA+HMz3jBzbmgSANr8M4wwKD-SbVPrnsMdXqKnN+sa+S79r=P1w@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=utf-8
Message-Id: <76EC11A8-968B-43B8-BE90-A4FE68644C6B@163.com>
Cc: Harry Wei <harryxiyou@gmail.com>,
        Greg-Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "kernel@vger.linux-kernel.cn" <kernel@vger.linux-kernel.cn>,
        Russell King <linux@arm.linux.org.uk>
X-Mailer: iPod Mail (9B206)
From: PT <platinum@163.com>
Subject: Re: [PATCH] Chinese translation of Documentation/arm/Booting
Date: Tue, 28 Aug 2012 07:36:30 -0700
To: Ninja Tekkaman <tekkamanninja@gmail.com>
X-CM-TRANSID: DtGowECZWGR01zxQH8xMAg--.9969S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Jr4UuFyfAF1DJw4fJr48Xrb_yoWxtw1Upr
	s3Gr17G348Zw18WF4xXryUWrsxXryYgayUJrn7K3s7XF12yr17X34rKry8XrWDJFyrJF1j
	q3W7CFnIyryDJrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jca93UUUUU=
X-CM-SenderInfo: xsod3xxqxpqiywtou0bp/1tbiGRkZtU9o1l-wxQAAs3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7SEbT6H018042

看了几封中文文档翻译的 patch，觉得很不错！
如果中文和英文、数字之间能有个半角空格就更好了，无论是美观度、可读性还是超链都不会有问题。

发自我的 iPod

在 2012-8-28，7:29，Ninja Tekkaman <tekkamanninja@gmail.com> 写道：

> This is a Chinese translated version of Documentation/arm/Booting
> 
> Signed-off-by: Fu Wei <tekkamanninja@gmail.com>
> ---
> diff --git a/Documentation/zh_CN/arm/Booting b/Documentation/zh_CN/arm/Booting
> new file mode 100644
> index 0000000..e0b1673
> --- /dev/null
> +++ b/Documentation/zh_CN/arm/Booting
> @@ -0,0 +1,175 @@
> +﻿Chinese translated version of Documentation/arm/Booting
> +
> +If you have any comment or update to the content, please contact the
> +original document maintainer directly.  However, if you have a problem
> +communicating in English you can also ask the Chinese maintainer for
> +help.  Contact the Chinese maintainer if this translation is outdated
> +or if there is a problem with the translation.
> +
> +Maintainer: Russell King <linux@arm.linux.org.uk>
> +Chinese maintainer: Fu Wei <tekkamanninja@gmail.com>
> +---------------------------------------------------------------------
> +Documentation/arm/Booting 的中文翻译
> +
> +如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
> +交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
> +译存在问题，请联系中文版维护者。
> +
> +英文版维护者： Russell King <linux@arm.linux.org.uk>
> +中文版维护者： 傅炜  Fu Wei <tekkamanninja@gmail.com>
> +中文版翻译者： 傅炜  Fu Wei <tekkamanninja@gmail.com>
> +中文版校译者： 傅炜  Fu Wei <tekkamanninja@gmail.com>
> +
> +以下为正文
> +---------------------------------------------------------------------
> +
> +            启动 ARM Linux
> +            =================
> +
> +作者：Russell King
> +日期：2002年5月18日
> +
> +以下文档适用于 2.4.18-rmk6 及以上版本。
> +
> +为了启动ARM Linux，你需要一个引导装载程序（boot loader），
> +它是一个在主内核启动前运行的一个小程序。引导装载程序需要初始化各种设备，
> +并最终调用Linux内核，将信息传递给内核。
> +
> +从本质上讲，引导装载程序应提供（至少）以下功能：
> +
> +1、设置和初始化RAM。
> +2、初始化一个串口。
> +3、检测机器的类型（machine type）。
> +4、设置内核标签列表（tagged list）。
> +5、调用内核映像。
> +
> +
> +1、设置和初始化RAM
> +------------------
> +
> +现有的引导加载程序:        强制
> +新开发的引导加载程序:        强制
> +
> +引导装载程序应该找到并初始化系统中所有内核用于保持系统变量数据的RAM。
> +这个操作的执行是设备依赖的。（它可能使用内部算法来自动定位和计算所有
> +RAM，或可能使用对这个设备已知的RAM信息，还可能使用任何引导装载程序
> +设计者想到的匹配方法。）
> +
> +
> +2、初始化一个串口
> +-----------------------------
> +
> +现有的引导加载程序:        可选、建议
> +新开发的引导加载程序:        可选、建议
> +
> +引导加载程序应该初始化并使能一个目标板上的串口。这允许内核串口驱动
> +自动检测哪个串口用于内核控制台。(一般用于调试或与目标板通信。)
> +
> +作为替代方案，引导加载程序也可以通过标签列表传递相关的'console='选项
> +给内核以指定某个串口，而串口数据格式的选项在以下文档中描述：
> +
> +       Documentation/kernel-parameters.txt。
> +
> +
> +3、检测机器类型
> +--------------------------
> +
> +现有的引导加载程序:        可选
> +新开发的引导加载程序:        强制
> +
> +引导加载程序应该通过某些方式检测自身所处的机器类型。这是一个硬件
> +代码或通过查看所连接的硬件用某些算法得到，这些超出了本文档的范围。
> +引导加载程序最终必须能提供一个MACH_TYPE_xxx值给内核。
> +(详见linux/arch/arm/tools/mach-types)。
> +
> +4、设置启动数据
> +------------------
> +
> +现有的引导加载程序:        可选、强烈建议
> +新开发的引导加载程序:        强制
> +
> +引导加载程序必须提供标签列表或者dtb映像以传递配置数据给内核。启动
> +数据的物理地址通过寄存器r2传递给内核。
> +
> +4a、设置内核标签列表
> +--------------------------------
> +
> +bootloader必须创建和初始化内核标签列表。一个有效的标签列表以
> +ATAG_CORE标签开始，并以ATAG_NONE标签结束。ATAG_CORE标签可以是空的，
> +也可以是非空。一个空ATAG_CORE标签其size域设置为‘2’(0x00000002)。
> +ATAG_NONE标签的 size 域必须设置为零。
> +
> +在列表中可以保存任意数量的标签。对于一个重复的标签是追加到之前标签
> +所携带的信息之后，还是会覆盖原来的信息，是未定义的。某些标签的行为
> +是前者，其他是后者。
> +
> +bootloader必须传递一个系统内存的位置和最小值，以及根文件系统位置。
> +因此，最小的标签列表如下所示：
> +
> +        +-----------+
> +基地址 ->    | ATAG_CORE |  |
> +        +-----------+  |
> +        | ATAG_MEM  |  | 地址增长方向
> +        +-----------+  |
> +        | ATAG_NONE |  |
> +        +-----------+  v
> +
> +标签列表应该保存在系统的RAM中。
> +
> +标签列表必须置于内核自解压和initrd'bootp'程序都不会覆盖的内存区。
> +建议放在RAM的头16KiB中。
> +
> +4b、设置设备树
> +-------------------------
> +
> +bootloader必须以64bit地址对齐的形式加载一个设备树映像 (dtb) 到系统
> +RAM中，并用启动数据初始化它。dtb格式在文档
> +Documentation/devicetree/booting-without-of.txt中。内核将会在dtb
> +物理地址处查找dtb魔数值（0xd00dfeed），以确定dtb是否已经代替标签列表
> +被传递进来。
> +
> +bootloader必须传递一个系统内存的位置和最小值，以及根文件系统位置。
> +dtb必须置于内核自解压不会覆盖的内存区。建议将其放置于RAM的头16KiB中。
> +但是不可将其放置于“0”物理地址处，因为内核认为：r2中为0，意味着没有
> +标签列表和dtb传递过来。
> +
> +5、调用内核映像
> +---------------------------
> +
> +现有的引导加载程序:        强制
> +新开发的引导加载程序:        强制
> +
> +调用内核映像zImage有两个选择。如果zImge保存在flash中，且是为了在
> +flash中直接运行而被正确链接的。这样引导加载程序就可以在flash中直接
> +调用zImage。
> +
> +zImage也可以被放在系统RAM（任意位置）中被调用。注意：内核使用映像
> +基地址的前16KB RAM空间来保存页表。建议将映像置于RAM的32KB处。
> +
> +对于以上任意一种情况，都必须符合以下启动状态：
> +
> +- 停止所有DMA设备，这样内存数据就不会因为虚假网络包或磁盘数据而被破坏。
> +  这可能可以节省你许多的调试时间。
> +
> +- CPU 寄存器配置
> +  r0 = 0，
> +  r1 = （在上面3中获取的）机器类型码。
> +  r2 = 标签列表在系统RAM中的物理地址，或
> +       设备树块(dtb)在系统RAM中的物理地址
> +
> +- CPU 模式
> +  所有形式的中断必须被禁止 (IRQs 和 FIQs)
> +  CPU 必须处于 SVC 模式。(对于 Angel 调试有特例存在)
> +
> +- 缓存，MMUs
> +  MMU 必须关闭。
> +  指令缓存开启或关闭都可以。
> +  数据缓存必须关闭。
> +
> +- 引导加载程序应该通过直接跳转到内核映像的第一条指令来调用内核映像。
> +
> +  对于支持 ARM 指令集的CPU，跳入内核入口时必须处在ARM状态，即使对于
> +  Thumb-2内核也是如此。
> +
> +  对于仅支持 Thumb 指令集的CPU，比如 Cortex-M 系列的 CPU，跳入内核
> +  入口时必须处于Thumb状态。
> -- 
> 1.7.9.5
> Т��ХF�V�7V'67&�&Rg&��F��2Ɨ7C�6V�BF�RƖ�R'V�7V'67&�&R�W&�V�"��ЧF�R&�G��b�W76vRF����&F���fvW"�Ɩ�W�ֶW&�V��6�Ф��&R���&F�����f�B�GG���fvW"�Ɩ�W�ֶW&�V��6�
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
