Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700Ab0JSIwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:52:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35666 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933423Ab0JSIwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:52:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [RFC][Patch] Adding kmsg_dump() to reboot/halt/poweroff/emergency_restart path
Cc: kosaki.motohiro@jp.fujitsu.com,
        "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anders.grafstrom@netinsight.net" <anders.grafstrom@netinsight.net>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eparis@redhat.com" <eparis@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C11B4B724@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C11B4B724@USINDEVS01.corp.hds.com>
Message-Id: <20101019173303.A205.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 Oct 2010 17:52:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> Final messages from reboot, halt and poweroff aren't output to disk because klogd/syslogd 
> has been killed and root file system has been turned read-only.
> 
> Final messages from emergency_restart aren't output to disk as well because system may
> reboot before klogd/syslogd outputs messages to disk.
> 
> Therefore, it is better to put kmsg_dumper in reboot/halt/poweroff/emergency_restart path.
> Any comments/advices are welcome.

I think mtdoops user don't want to dump logs if a system reboot/poweroff
safely because mtd device have write count limitation. and they are main
user of kmsg_dump().

But if they ack this one, I have no objection.

Thanks.


