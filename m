Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab2CUHdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 03:33:40 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45920 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2CUHdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 03:33:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6655"; a="172039443"
Message-ID: <4F698452.1080102@codeaurora.org>
Date: Wed, 21 Mar 2012 00:33:38 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, hsweeten@visionengravers.com
Subject: Re: [PATCH RFC] debugfs: rename, export, and use default_open() as
 debugfs_default_open()
References: <201203201547.05656.hartleys@visionengravers.com>
In-Reply-To: <201203201547.05656.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/20/2012 3:47 PM, H Hartley Sweeten wrote:
> Rename default_open() in fs/debugfs/file.c to debugfs_default_open()
> and export it for use by the many debugfs open() methods that simply
> do:
>
> static int foo_open(struct inode *inode, struct file *file)
> {
> 	file->private_data = inode->i_private;
> 	return 0;
> }
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> ---
>

I sent a patch to introduce simple_open() which is this function ripped
from debugfs code. I also sent a patch to fixup all the callers
(including the non-debugfs ones). Seems like we arrived at the same
thing. Andrew has picked it up and it is in -mm.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

