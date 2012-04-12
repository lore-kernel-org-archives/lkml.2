Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab2DLXBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 19:01:05 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:64548 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab2DLXBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 19:01:03 -0400
Date: Thu, 12 Apr 2012 16:00:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: zhangyanfei <zhangyanfei@cn.fujitsu.com>
Cc: avi@redhat.com, mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        joerg.roedel@amd.com, dzickus@redhat.com, paul.gortmaker@windriver.com,
        gregkh@suse.de, ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 3/4] ksysfs: export VMCSINFO via sysfs
Message-ID: <20120412230058.GA23292@kroah.com>
References: <4F84E0DF.8040206@cn.fujitsu.com>
 <4F84E50E.2090008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F84E50E.2090008@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 09:57:34AM +0800, zhangyanfei wrote:
> This patch creates sysfs file to export where VMCSINFO is allocated,
> as below:
>         $ cat /sys/kernel/vmcsinfo
>         1cb88a0 2000
> number on the left-hand side is the physical address of VMCSINFO,
> while the one on the right-hand side is the max size of VMCSINFO.

Ick, why do you have 2 values in one sysfs file, that's not nice, or
good.

What's wrong with 2 different files?

Also, any new sysfs file you add needs to also have a Documentation/ABI
entry added as well.

But we can't accept this as-is, sorry, please split it up into 2 files.

greg k-h
