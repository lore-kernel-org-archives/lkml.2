Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2K3IfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:35:05 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:59244 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2K3IfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:35:03 -0500
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>,
        "'Joel Becker'" <jlbec@evilplan.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
References: <20121129164123.GA8551@linutronix.de>
In-reply-to: <20121129164123.GA8551@linutronix.de>
Subject: RE: [PATCH] fs/configfs: allow to create groups on demand
Date: Fri, 30 Nov 2012 09:34:53 +0100
Message-id: <001401cdced5$93506d90$b9f148b0$%p@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3OUGKRaw7lKNzjTfmZAe+1/8eLxQAhK5/w
Content-language: pl
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 29, 2012 5:41 PM Sebastian Andrzej Siewior wrote:
> Subject: [PATCH] fs/configfs: allow to create groups on demand
> 
> This patch adds a function add a group to an existing one and its
> counterart. The newly created group behaves as it would be created via
> default_groups[] which means the user can't rmdir it.
> This should be used by the upcomming USB gadget interface in order to
> add the currently available UDCs as a child of the UDC node. The UDC
> itself will appear once the hardware driver is loaded and can appear
> later.

Yeah, this mode of operation will be required.

> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  fs/configfs/dir.c        |   63 ++++++++++++++++++++++++++++++++++-------
> -----
>  include/linux/configfs.h |    4 +++
>  2 files changed, 51 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
> index 7414ae2..50ee2bd 100644
> --- a/fs/configfs/dir.c
> +++ b/fs/configfs/dir.c
> @@ -1663,19 +1663,13 @@ const struct file_operations
> configfs_dir_operations = {
>  	.readdir	= configfs_readdir,
>  };
> 
> -int configfs_register_subsystem(struct configfs_subsystem *subsys)
> +static int __create_group(struct config_group *group, struct dentry
*root)
>  {

Can __create_group be also used in create_default_group?


Andrzej



