Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0LIJJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:09:07 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:64603 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab0LIJJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:09:02 -0500
From: Lasse Collin <lasse.collin@tukaani.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH 2/2] Squashfs: Add XZ compression configuration option
Date: Thu, 9 Dec 2010 11:09:31 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-ARCH; KDE/4.5.4; x86_64; ; )
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Linux Embedded Maillist <linux-embedded@vger.kernel.org>
References: <4D007315.1090704@lougher.demon.co.uk>
In-Reply-To: <4D007315.1090704@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012091109.32084.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-09 Phillip Lougher wrote:
> +config SQUASHFS_XZ
> +       bool "Include support for XZ compressed file systems"
> +       depends on SQUASHFS
> +       default n
> +       select XZ_DEC

Should "select XZ_DEC" be replaced with "depends on XZ_DEC"? XZ_DEC 
requires CRC32, so if "select XZ_DEC" is used, there needs to be also 
"select CRC32".

XZ_DEC may optionally use other XZ_DEC_* symbols, which the user will 
want to choose when building for an embedded system. With "depends on 
XZ_DEC" the user will see that there's more than a single option that 
affects the details of the XZ support in Squashfs.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
