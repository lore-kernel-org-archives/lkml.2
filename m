Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741Ab0JSIz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:55:56 -0400
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:52635 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933658Ab0JSIzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:55:54 -0400
Subject: Re: [RFC][Patch] Adding kmsg_dump() to
 reboot/halt/poweroff/emergency_restart path
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: ext KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anders.grafstrom@netinsight.net" <anders.grafstrom@netinsight.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eparis@redhat.com" <eparis@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
In-Reply-To: <20101019173303.A205.A69D9226@jp.fujitsu.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C11B4B724@USINDEVS01.corp.hds.com>
	 <20101019173303.A205.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Tue, 19 Oct 2010 11:51:12 +0300
Message-ID: <1287478272.9272.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 10:52 +0200, ext KOSAKI Motohiro wrote:
> > Hi,
> > 
> > Final messages from reboot, halt and poweroff aren't output to disk because klogd/syslogd 
> > has been killed and root file system has been turned read-only.
> > 
> > Final messages from emergency_restart aren't output to disk as well because system may
> > reboot before klogd/syslogd outputs messages to disk.
> > 
> > Therefore, it is better to put kmsg_dumper in reboot/halt/poweroff/emergency_restart path.
> > Any comments/advices are welcome.
> 
> I think mtdoops user don't want to dump logs if a system reboot/poweroff
> safely because mtd device have write count limitation. and they are main
> user of kmsg_dump().

Right, at least this is how we use mtdoops - we log crashes.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

