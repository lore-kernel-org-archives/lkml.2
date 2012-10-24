Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab2JXQDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:03:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41214 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab2JXQDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:03:10 -0400
Date: Thu, 25 Oct 2012 00:02:53 +0800
From: Tekkaman Ninja <tekkamanninja@gmail.com>
To: Harry Wei <harryxiyou@gmail.com>
Cc: Greg-Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel@vger.linux-kernel.cn, Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH]Documentation:Chinese translation of
 Documentation/arm64/memory.txt
Message-ID: <20121024160253.GB6567@Super-MAGI>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a Chinese translated version of
Documentation/arm64/memory.txt

Signed-off-by: Fu Wei <tekkamanninja@gmail.com>

---
 Documentation/zh_CN/arm64/memory.txt |   93 ++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)
 create mode 100644 Documentation/zh_CN/arm64/memory.txt

diff --git a/Documentation/zh_CN/arm64/memory.txt b/Documentation/zh_CN/arm64/memory.txt
new file mode 100644
index 0000000..83b5193
--- /dev/null
+++ b/Documentation/zh_CN/arm64/memory.txt
@@ -0,0 +1,93 @@
+Chinese translated version of Documentation/arm64/memory.txt
+
+If you have any comment or update to the content, please contact the
+original document maintainer directly.  However, if you have a problem
+communicating in English you can also ask the Chinese maintainer for
+help.  Contact the Chinese maintainer if this translation is outdated
+or if there is a problem with the translation.
+
+Maintainer: Catalin Marinas <catalin.marinas@arm.com>
+Chinese maintainer: Fu Wei <tekkamanninja@gmail.com>
+---------------------------------------------------------------------
+Documentation/arm64/memory.txt 的中文翻译
+
+如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
+交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
+译存在问题，请联系中文版维护者。
+
+英文版维护者： Catalin Marinas <catalin.marinas@arm.com>
+中文版维护者： 傅炜  Fu Wei <tekkamanninja@gmail.com>
+中文版翻译者： 傅炜  Fu Wei <tekkamanninja@gmail.com>
+中文版校译者： 傅炜  Fu Wei <tekkamanninja@gmail.com>
+
+以下为正文
+---------------------------------------------------------------------
+		     Linux 在 AArch64 中的内存布局
+		     ===========================
+
+作者: Catalin Marinas <catalin.marinas@arm.com>
+日期: 2012 年 02 月 20 日
+
+本文档描述 AArch64 Linux 内核所使用的虚拟内存布局。此构架可以实现
+页大小为 4KB 的 4 级转换表和页大小为 64KB 的 3 级转换表。
+
+AArch64 Linux 使用页大小为 4KB 的 3 级转换表配置，对于用户和内核
+都有 39-bit (512GB) 的虚拟地址空间。对于页大小为 64KB的配置，仅
+使用 2 级转换表，但内存布局相同。
+
+用户地址空间的 63:39 位为 0，而内核地址空间的相应位为 1。TTBRx 的
+选择由虚拟地址的 63 位给出。swapper_pg_dir 仅包含内核（全局）映射，
+而用户 pgd 仅包含用户（非全局）映射。swapper_pgd_dir 地址被写入
+TTBR1 中，且从不写入 TTBR0。
+
+
+AArch64 Linux 内存布局：
+
+起始地址			结束地址			大小		用途
+-----------------------------------------------------------------------
+0000000000000000	0000007fffffffff	 512GB		用户空间
+
+ffffff8000000000	ffffffbbfffcffff	~240GB		vmalloc
+
+ffffffbbfffd0000	ffffffbcfffdffff	  64KB		[防护页]
+
+ffffffbbfffe0000	ffffffbcfffeffff	  64KB		PCI I/O 空间
+
+ffffffbbffff0000	ffffffbcffffffff	  64KB		[防护页]
+
+ffffffbc00000000	ffffffbdffffffff	   8GB		vmemmap
+
+ffffffbe00000000	ffffffbffbffffff	  ~8GB		[防护页，未来用于 vmmemap]
+
+ffffffbffc000000	ffffffbfffffffff	  64MB		模块
+
+ffffffc000000000	ffffffffffffffff	 256GB		内存空间
+
+
+4KB 页大小的转换表查找：
+
++--------+--------+--------+--------+--------+--------+--------+--------+
+|63    56|55    48|47    40|39    32|31    24|23    16|15     8|7      0|
++--------+--------+--------+--------+--------+--------+--------+--------+
+ |                 |         |         |         |         |
+ |                 |         |         |         |         v
+ |                 |         |         |         |   [11:0]  页内偏移
+ |                 |         |         |         +-> [20:12] L3 索引
+ |                 |         |         +-----------> [29:21] L2 索引
+ |                 |         +---------------------> [38:30] L1 索引
+ |                 +-------------------------------> [47:39] L0 索引 (未使用)
+ +-------------------------------------------------> [63] TTBR0/1
+
+
+64KB 页大小的转换表查找：
+
++--------+--------+--------+--------+--------+--------+--------+--------+
+|63    56|55    48|47    40|39    32|31    24|23    16|15     8|7      0|
++--------+--------+--------+--------+--------+--------+--------+--------+
+ |                 |    |               |              |
+ |                 |    |               |              v
+ |                 |    |               |            [15:0]  页内偏移
+ |                 |    |               +----------> [28:16] L3 索引
+ |                 |    +--------------------------> [41:29] L2 索引 (仅使用 38:29 )
+ |                 +-------------------------------> [47:42] L1 索引 (未使用)
+ +-------------------------------------------------> [63] TTBR0/1
-- 
1.7.9.5

