Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab0DNHq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 03:46:27 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36118 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab0DNHqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 03:46:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JKF7SO6rJ6nifdsoYEWuHIhbwMfa6P26FBW7FLYawmkrjxF9FbA6Jo0MUzkLVwVHEb
         TpGznYJuQg9Dqlo7FLZkpR43EtS8pY5J29fDBRYYQOlqfEmkQ8wZFeCv+P3cDjeqV+gj
         ANRRctsbVRa3cLvNorSBcsKIt1MaO4+KqubtQ=
Date: Wed, 14 Apr 2010 15:50:09 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix sdev_rw_attr macro for scsi device sysfs entries
Message-ID: <20100414075009.GC4503@cr0.nay.redhat.com>
References: <4BC55D72.7080301@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC55D72.7080301@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 03:15:14PM +0900, Tomohiro Kusumi wrote:
>Hi
>
>This patch fixes sdev_rw_attr() macro for scsi device sysfs entries.
>It seems there is no such function snscanf in the current linux kernel,

Yes! Good catch!


>so it fails to compile scsi driver when someone try to add a new rw entry.
>This has been unfixed for a long time probably because current scsi device
>has no rw entries.
>

Really? I compiled it in my configuration, but i don't see any
compile error. Hmm, i think we are lucky, no one is using the macro
sdev_rw_attr() currently.


># grep snscanf . -rn
>./drivers/scsi/scsi_sysfs.c:489:        snscanf (buf, 20, format_string, &sdev->field);                 \
>
>Thanks,
>Tomohiro Kusumi
>
>
>
>Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!
