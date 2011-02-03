Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab1BCCHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 21:07:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab1BCCHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 21:07:40 -0500
Date: Wed, 2 Feb 2011 21:07:03 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>, akpm@linux-foundation.org
Subject: Re: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about
 kdump_msg hook into crash_kexec())
Message-ID: <20110203020703.GB21603@redhat.com>
References: <20110201073853.GB21239@cr0.nay.redhat.com>
 <20110201081313.GC21239@cr0.nay.redhat.com>
 <20110203095837.93A2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110203095837.93A2.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 09:59:04AM +0900, KOSAKI Motohiro wrote:
> > On Tue, Feb 01, 2011 at 03:38:53PM +0800, Américo Wang wrote:
> > >On Mon, Jan 31, 2011 at 11:33:15PM -0800, Eric W. Biederman wrote:
> > >>The issue is the inane call inside crash_kexec.
> > >>
> > >>It requires both a kexec kernel to be loaded and it requires you to be
> > >>crashing.  Given that when I audited the kmsg_dump handlers they really
> > >>weren't safe in a crash dump scenario we should just remove it.
> > >>
> > >
> > >Probably, I think we need to get rid of KMSG_DUMP_KEXEC.
> > >
> > 
> > Here we go.
> > 
> > --------->
> > 
> > KMSG_DUMP_KEXEC is useless because we already save kernel messages
> > inside /proc/vmcore, and it is unsafe to allow modules to do
> > other stuffs in a crash dump scenario.
> > 
> > Reported-by: Vivek Goyal <vgoyal@redhat.com>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> I wrote why this is no good idea by another mail. Please see it.
> Anyway you have a right to don't use this feature.
> 

But you have not explained that why do you need to hook into crash_kexec()
and you have also not explained why do you need to send out kdump_msg()
notification if kdump is configured.

Some detailed explanation here would help.

Thanks
Vivek

> Nack.
> 
