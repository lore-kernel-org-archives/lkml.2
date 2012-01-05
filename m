Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab2AEVBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:01:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758265Ab2AEVBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:01:45 -0500
Date: Thu, 5 Jan 2012 16:01:23 -0500
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
Message-ID: <20120105210123.GI5650@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF7F@USINDEVS01.corp.hds.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF81@USINDEVS01.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28FBB21@ORSMSX104.amr.corp.intel.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827B01D@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C5827B01D@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 03:10:25PM -0500, Seiji Aguchi wrote:
> 
> >Aren't you worried about the comment about smp_send_stop() not
> >being hardened to work in a panic situation?
> > 	/*
> > 	 * Note smp_send_stop is the usual smp shutdown function, which
> > 	 * unfortunately means it may not be hardened to work in a panic
> 
> This comment is wrong because Don improved smp_send_stop() by switching REBOOT_VECTOR to NMI.
> And his patch has already merged to linux-next tree.

I only fixed x86.  Who knows what the other arches do..

I don't know how to prove something is hardened other than not seeing any
hangs or false reboots on in that piece of code.

Cheers,
Don

> 
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=3603a2512f9e69dc87914ba922eb4a0812b21cd6
> 
> So, current smp_send_stop() is hardened to work in a panic situation.
> 
> I will remove this wrong comment.
> 
> Seiji
> 
> >-----Original Message-----
> >From: Luck, Tony [mailto:tony.luck@intel.com]
> >Sent: Thursday, January 05, 2012 2:07 PM
> >To: Seiji Aguchi; Don Zickus
> >Cc: linux-kernel@vger.kernel.org; Matthew Garrett; Vivek Goyal; Chen, Gong; akpm@linux-foundation.org; Brown, Len;
> >'ying.huang@intel.com'; 'ak@linux.intel.com'; 'hughd@chromium.org'; 'mingo@elte.hu'; jmorris@namei.org;
> >a.p.zijlstra@chello.nl; namhyung@gmail.com; dle-develop@lists.sourceforge.net; Satoru Moriya
> >Subject: RE: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop()
> >
> >-	kmsg_dump(KMSG_DUMP_PANIC);
> >-
> > 	/*
> > 	 * Note smp_send_stop is the usual smp shutdown function, which
> > 	 * unfortunately means it may not be hardened to work in a panic
> >@@ -117,6 +115,8 @@ void panic(const char *fmt, ...)
> > 	 */
> > 	smp_send_stop();
> >
> >+	kmsg_dump(KMSG_DUMP_PANIC);
> >+
> >
> >Aren't you worried about the comment about smp_send_stop() not
> >being hardened to work in a panic situation?
> >
> >If it does work - we are clearly much better off moving the
> >kmsg_dump() call down like this. It makes life much simpler
> >and cleaner to work with just one running cpu.
> >
> >But if something goes wrong - we might not see the dump at all!
> >
> >How do we compare these cases and decide that it is better to
> >trust that smp_send_stop() will return?
> >
> >-Tony
