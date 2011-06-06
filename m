Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab1FFV0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:26:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50323 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1FFV0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:26:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] seq_file.h: introduce DECLARE_SEQ_FOPS_{RO,RW}
Date: Mon, 6 Jun 2011 23:26:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <201106061319.45855.hartleys@visionengravers.com> <20110606210755.GL11521@ZenIV.linux.org.uk> <ADE657CA350FB648AAC2C43247A983F001F3820B7C57@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F3820B7C57@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106062326.44103.arnd@arndb.de>
X-Provags-ID: V02:K0:mFc4x669qPF7CByFLb2PVqOFutRGYNOrFeRPUo2m1Ti
 w4fkPkHafUJ2+eGZJD6Ffxund1LqZsH69S3zz4Z5wM1rN9bJjS
 ELPGKydVxUHKjHooG/fE8Gz4m3kgtErqS8NyC8NyGgowSVpJi+
 ML7kDQRJjMS5ihBfqx8aT/J8D5vzF6jfqohUk3VoIIi4b8Ny+s
 3WeiyUZB61ZyEKvGrHGcw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 June 2011 23:19:15 H Hartley Sweeten wrote:
> Just an FYI, the exact same thing is being done with DEFINE_SIMPLE_ATTRIBUTE
> in fs.h:
> 
> #define DEFINE_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)            \
> static int __fops ## _open(struct inode *inode, struct file *file)      \
> {                                                                       \
>         __simple_attr_check_format(__fmt, 0ull);                        \
>         return simple_attr_open(inode, file, __get, __set, __fmt);      \
> }                                                                       \
> static const struct file_operations __fops = {                          \
>         .owner   = THIS_MODULE,                                         \
>         .open    = __fops ## _open,                                     \
>         .release = simple_attr_release,                                 \
>         .read    = simple_attr_read,                                    \
>         .write   = simple_attr_write,                                   \
>         .llseek  = generic_file_llseek,                                 \
> };

The main difference here is that the arguments to the macro are used directly
in the file operations, which makes it possible to grep for them.

	Arnd
