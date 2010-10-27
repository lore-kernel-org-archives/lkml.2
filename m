Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0J0Xgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 19:36:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515Ab0J0Xga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 19:36:30 -0400
Date: Wed, 27 Oct 2010 16:35:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem.Bityutskiy@nokia.com
Cc: ext KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anders.grafstrom@netinsight.net" <anders.grafstrom@netinsight.net>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eparis@redhat.com" <eparis@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][Patch] Adding kmsg_dump() to
 reboot/halt/poweroff/emergency_restart path
Message-Id: <20101027163505.c88095da.akpm@linux-foundation.org>
In-Reply-To: <1287478272.9272.9.camel@localhost>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C11B4B724@USINDEVS01.corp.hds.com>
	<20101019173303.A205.A69D9226@jp.fujitsu.com>
	<1287478272.9272.9.camel@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 11:51:12 +0300
Artem Bityutskiy <Artem.Bityutskiy@nokia.com> wrote:

> On Tue, 2010-10-19 at 10:52 +0200, ext KOSAKI Motohiro wrote:
> > > Hi,
> > > 
> > > Final messages from reboot, halt and poweroff aren't output to disk because klogd/syslogd 
> > > has been killed and root file system has been turned read-only.
> > > 
> > > Final messages from emergency_restart aren't output to disk as well because system may
> > > reboot before klogd/syslogd outputs messages to disk.
> > > 
> > > Therefore, it is better to put kmsg_dumper in reboot/halt/poweroff/emergency_restart path.
> > > Any comments/advices are welcome.
> > 
> > I think mtdoops user don't want to dump logs if a system reboot/poweroff
> > safely because mtd device have write count limitation. and they are main
> > user of kmsg_dump().

mtdoops was the only user until ramoops came along.

> Right, at least this is how we use mtdoops - we log crashes.

Fair enough.  So I suppose the existing clients (mtdoops_do_dump and
ramoops_do_dump) should be altered to inspect the `reason' argument,
and return if it isn't KMSG_DUMP_OOPS, KMSG_DUMP_PANIC or
KMSG_DUMP_KEXEC (I assume?)

If that sounds suitable then I'd ask Seiji to update and resend the
patch, along with a complete changelog as earlier dicussed.

I'd suggest doing it as two patches, the first of which alters mtdoops
and ramoops to perform their actions only for the appropriate `reason'
values.

