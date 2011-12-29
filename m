Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1L2D53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 22:57:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64931 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab1L2D52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 22:57:28 -0500
Message-ID: <4EFBE4EB.3040001@cn.fujitsu.com>
Date: Thu, 29 Dec 2011 11:56:27 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
CC: gaowanlong@cn.fujitsu.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: Bug in BLKBSZSET/GET ioctl ?
References: <4EFBE3D1.5030608@cn.fujitsu.com>
In-Reply-To: <4EFBE3D1.5030608@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-29 11:56:38,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-29 11:56:38,
	Serialize complete at 2011-12-29 11:56:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2011 11:51 AM, Wanlong Gao wrote:

> Hi all:
> 
> This is first reported to *libguestfs*: https://bugzilla.redhat.com/show_bug.cgi?id=624335


The blockdev-get/setbsz in *libguestfs* is just a wraper of util-linux's *blockdev --get/setbsz*.

> 
> Then, I looked into upstream util-linux and it seems nothing wrong. I'm not convinced that it's a kernel bug.
> 
> produce:
> 
> ---
> # ./util-linux/disk-utils/blockdev --getbsz /dev/sda6
> 4096
> # ./util-linux/disk-utils/blockdev --setbsz 2048 /dev/sda6
> # ./util-linux/disk-utils/blockdev --getbsz /dev/sda6
> 4096
> # ./util-linux/disk-utils/blockdev --setbsz 512 /dev/sda6
> # ./util-linux/disk-utils/blockdev --getbsz /dev/sda6
> 4096
> 
> ---
> 
> I'm not sure if it is related to write-back, but still CCed to Fengguang.
> 
> 
> 
> Thanks,
> -Wanlong Gao


