Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab0KYBdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 20:33:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab0KYBds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 20:33:48 -0500
Date: Wed, 24 Nov 2010 20:33:36 -0500
From: Dave Jones <davej@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: rcu_read_lock/unlock protect find_task_by_vpid call in
 migrate_pages
Message-ID: <20101125013336.GA2854@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20101125003339.GB31301@redhat.com>
 <20101125095012.F446.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101125095012.F446.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 09:50:37AM +0900, KOSAKI Motohiro wrote:
 
 > > @@ -1315,6 +1316,7 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
 > >  		goto out;
 > >  	}
 > >  	mm = get_task_mm(task);
 > > +	rcu_read_unlock();
 > >  	read_unlock(&tasklist_lock);
 > >  
 > >  	err = -EINVAL;
 > 
 > Thanks reporting. but mmotm seems already has the same patch.

indeed. It's also better than mine, which missed the unlock on error path.

thanks,

	Dave

