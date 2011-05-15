Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042Ab1EOPOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 11:14:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:24073 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756286Ab1EOPOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 11:14:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,369,1301900400"; 
   d="scan'208";a="1939157"
From: Andi Kleen <andi@firstfloor.org>
To: Alex Davis <alex14641@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Possible coding issue in udf??
References: <367853.39582.qm@web130121.mail.mud.yahoo.com>
Date: Sun, 15 May 2011 08:14:02 -0700
In-Reply-To: <367853.39582.qm@web130121.mail.mud.yahoo.com> (Alex Davis's
	message of "Fri, 13 May 2011 19:57:20 -0700 (PDT)")
Message-ID: <m2k4dsnghx.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Davis <alex14641@yahoo.com> writes:

> In fs/udf/inode.c, line 1455, linux 2.6.35, there is the following code:
>
> 	udfperms = ((inode->i_mode & S_IRWXO)) |
> 		   ((inode->i_mode & S_IRWXG) << 2) |
> 		   ((inode->i_mode & S_IRWXU) << 4);
>
> Shouldn't we be shifting by 3 bits? i.e:
> 	udfperms = ((inode->i_mode & S_IRWXO)) |
> 		   ((inode->i_mode & S_IRWXG) << 3) |
> 		   ((inode->i_mode & S_IRWXU) << 6);
>
> The S_I.. constants are all defined in include/linux/stat.h as 3-bit values.
>
> I will send a patch if needed.

I  would suggest you test it first. Put in a UDF disk that triggers
this case (verify with a printk). Check in ls -l if the 
permissions are correct or wrong.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
