Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab2FLL6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:58:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38580 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2FLL6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:58:31 -0400
Date: Tue, 12 Jun 2012 19:58:21 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH v2] writeback: avoid race when update bandwidth
Message-ID: <20120612115746.GA3980@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1339501561-4570-1-git-send-email-liwp.linux@gmail.com>
 <20120612115219.GA17348@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120612115219.GA17348@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 07:52:19PM +0800, Fengguang Wu wrote:
>On Tue, Jun 12, 2012 at 07:46:01PM +0800, Wanpeng Li wrote:
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>> 
>> "V1 -> V2"
>> * remove dirty_lock
>> 
>> Since bdi->wb.list_lock is used to protect the b_* lists,
>> so the flushers who call wb_writeback to writeback pages will
>> stuck when bandwidth update policy holds this lock. In order
>> to avoid this race we can introduce a new bandwidth_lock who
>> is responsible for protecting bandwidth update policy.
>> 
>> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>
>Applied with a new title "writeback: use a standalone lock for
>updating write bandwidth". "race" is sensitive because it often
>refers to some locking error.

OK, Thanks a lot.

Regards,
Wanpeng Li
