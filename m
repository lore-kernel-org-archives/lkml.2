Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab0IWF40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 01:56:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730Ab0IWF4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 01:56:25 -0400
Date: Wed, 22 Sep 2010 22:56:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alessandro Guido <ag@alessandroguido.name>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: idr_remove called for id=0 which is not allocated
Message-Id: <20100922225612.826b0553.akpm@linux-foundation.org>
In-Reply-To: <4C9A70B2.3090101@alessandroguido.name>
References: <4C9A70B2.3090101@alessandroguido.name>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 23:10:10 +0200 Alessandro Guido <ag@alessandroguido.name> wrote:

> I have this traces in my logs (full dmesg attached).
> 
> idr_remove called for id=0 which is not allocated.
> Pid: 1136, comm: Xorg Not tainted 2.6.36-rc5-49-gc79bd89 #1
> Call Trace:
>   [<c1379e16>] ? printk+0x18/0x1a
>   [<c113b8f3>] idr_remove+0x73/0x1c0
>   [<c11b8d6f>] drm_mode_object_put+0x2f/0x50
>   [<c11b8f6e>] drm_mode_destroy+0xe/0x20
>   [<c11eb24b>] nouveau_connector_get_modes+0x2b/0x390
>   [<c1185b6f>] ? acpi_lid_open+0x22/0x3c
>   [<c103800b>] ? queue_delayed_work+0x1b/0x30
>   [<c11abf34>] drm_helper_probe_single_connector_modes+0xc4/0x360
>   [<c11bb6a7>] drm_mode_getconnector+0x2a7/0x350
>   [<c11b00d2>] drm_ioctl+0x1c2/0x4b0
>   [<c1068071>] ? filemap_fault+0x81/0x3c0
>   [<c11bb400>] ? drm_mode_getconnector+0x0/0x350
>   [<c107bedf>] ? handle_mm_fault+0x13f/0x670
>   [<c11aff10>] ? drm_ioctl+0x0/0x4b0
>   [<c109c90d>] do_vfs_ioctl+0x7d/0x5f0
>   [<c101a14c>] ? do_page_fault+0x17c/0x3c0
>   [<c108fc6d>] ? vfs_write+0xfd/0x140
>   [<c108f1c0>] ? do_sync_write+0x0/0xe0
>   [<c109ceb9>] sys_ioctl+0x39/0x60
>   [<c1002b90>] sysenter_do_call+0x12/0x26

I assume this is a regression.  2.6.35 didn't do this?
