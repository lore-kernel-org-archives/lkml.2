Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab1BAQGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:06:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab1BAQGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:06:17 -0500
Date: Tue, 1 Feb 2011 11:06:02 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        kosaki.motohiro@jp.fujitsu.com,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org,
        Simon Kagstrom <simon.kagstrom@netinsight.net>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about
 kdump_msg hook into crash_kexec())
Message-ID: <20110201160602.GE2588@redhat.com>
References: <20110131225939.GH11974@redhat.com>
 <20110201071933.GA21239@cr0.nay.redhat.com>
 <m1hbcous3o.fsf@fess.ebiederm.org>
 <20110201073853.GB21239@cr0.nay.redhat.com>
 <20110201081313.GC21239@cr0.nay.redhat.com>
 <20110201152845.GB5363@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110201152845.GB5363@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 10:28:45AM -0500, Vivek Goyal wrote:
> On Tue, Feb 01, 2011 at 04:13:13PM +0800, Américo Wang wrote:
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
> 
> I think this is right thing to do. First of all kmsg_dump() call inside
> crash_kexec() does not make any sense. Secondly, if kdump kernel is
> loaded, we anyway are going to capture log buffers in vmcore and there
> should not be any need to try to save messages twice.
> 
> Now one can argue that what if kdump does not capture the dump. I think
> then right solution (though painful one) is to try to make kdump as
> reliable as possible instead of trying to come up with backup mechanisms
> to save logs in case kdump fails.

I'm of the same mind, kmsg_dump is fine by itself, but wedging it in to
duplicate something kdump already does on the grounds that kdump might
fail is Doing It Wrong. If one has concerns about kdump failing, put
effort into solidifying kdump.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

