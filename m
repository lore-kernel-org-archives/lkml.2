Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab2GCHKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 03:10:48 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:53599 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab2GCHKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 03:10:47 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap5MADya8k9V5qg+PGdsb2JhbABFihWsVhkBAQEBHhkNJ4IYAQEFOhwjEAgDGC4UJQoaiCK7OxSLJIU6YAOVNIVmjH8
X-IronPort-AV: E=Sophos;i="4.77,515,1336341600"; 
   d="scan'208";a="367476448"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 3 Jul 2012 09:11:02 +0200
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jan Beulich <jbeulich@suse.com>, Jiri Kosina <jkosina@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: hid/Kconfig:7:error: recursive dependency detected!
Message-ID: <20120703071102.GA5072@polaris.bitmath.org>
References: <20120703040640.GA8236@localhost>
 <20120703064407.GA4854@polaris.bitmath.org>
 <20120703064954.GB17367@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120703064954.GB17367@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 02:49:54PM +0800, Fengguang Wu wrote:
> On Tue, Jul 03, 2012 at 08:44:07AM +0200, Henrik Rydberg wrote:
> > Hi Fengguang,
> > 
> > > I got this error while doing randconfig test:
> > > 
> > >         drivers/hid/Kconfig:7:error: recursive dependency detected!
> > >         drivers/hid/Kconfig:7:  symbol HID is selected by USB_HID
> > >         drivers/hid/usbhid/Kconfig:4:   symbol USB_HID depends on HID
> > 
> > What kernel tree does this apply to? Reading through the code again
> > and testing your configuration, I cannot reproduce the
> > problem. Indeed, in my tree, USB_HID does not depend on HID.
> 
> Henrik, I'm testing on today's linux-next.

Ah, yes, I see it. The problem is also present in Jiri's for-next
tree. Jiri: the manual merge of drivers/hid/Kconfig seems to have gone
wrong; in particular, the source of the usbhid config is inside the
"if HID" statement, which creates the problem seen by Fengguang.

Thanks,
Henrik
