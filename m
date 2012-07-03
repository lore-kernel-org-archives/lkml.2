Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab2GCJVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:21:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab2GCJVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:21:02 -0400
Date: Tue, 3 Jul 2012 11:20:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jan Beulich <jbeulich@suse.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: hid/Kconfig:7:error: recursive dependency detected!
In-Reply-To: <20120703071102.GA5072@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1207031120010.17304@pobox.suse.cz>
References: <20120703040640.GA8236@localhost> <20120703064407.GA4854@polaris.bitmath.org> <20120703064954.GB17367@localhost> <20120703071102.GA5072@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2012, Henrik Rydberg wrote:

> > > > I got this error while doing randconfig test:
> > > > 
> > > >         drivers/hid/Kconfig:7:error: recursive dependency detected!
> > > >         drivers/hid/Kconfig:7:  symbol HID is selected by USB_HID
> > > >         drivers/hid/usbhid/Kconfig:4:   symbol USB_HID depends on HID
> > > 
> > > What kernel tree does this apply to? Reading through the code again
> > > and testing your configuration, I cannot reproduce the
> > > problem. Indeed, in my tree, USB_HID does not depend on HID.
> > 
> > Henrik, I'm testing on today's linux-next.
> 
> Ah, yes, I see it. The problem is also present in Jiri's for-next
> tree. Jiri: the manual merge of drivers/hid/Kconfig seems to have gone
> wrong; in particular, the source of the usbhid config is inside the
> "if HID" statement, which creates the problem seen by Fengguang.

Indeed, I messed up the conflict resolution. I have pushed the new 
for-next branch with proper resolution now.

Thanks,

-- 
Jiri Kosina
SUSE Labs
