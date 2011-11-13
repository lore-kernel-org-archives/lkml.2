Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab1KMUBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 15:01:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab1KMUBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 15:01:30 -0500
Date: Sun, 13 Nov 2011 21:01:28 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: KY Srinivasan <kys@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "joe@perches.com" <joe@perches.com>
Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
In-Reply-To: <20111107055109.GA21095@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1111132100000.15187@pobox.suse.cz>
References: <1319841316-29136-1-git-send-email-kys@microsoft.com> <20111105064739.GA31111@core.coreip.homeip.net> <6E21E5352C11B742B20C142EB499E0481AA68580@TK5EX14MBXC128.redmond.corp.microsoft.com> <20111107055109.GA21095@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Nov 2011, Dmitry Torokhov wrote:

> > I am not a hid expert; but all  hid low level drivers appear to do this.
> > Initially, I was directly invoking hid_connect() directly and based on your
> > Input, I chose to use hid_hw_start() which all other drivers are using.
> 
> Note that the users of hid_hw_start() actually are not low level
> drivers, such as usbhid or bluetooth hidp, but higher-level drivers,
> such as hid-wacom, hid-a4tech, etc. Since your driver is a low-level
> driver (a provider so to speak) it should not call hid_hw_start() on its
> own but rather wait for the hid code to do it.
> 
> Still, I am not a HID expert either so I'll defer to Jiri here.

Hi,

my understanding is that hv driver is actually a bit special in this 
respect -- it's actually all-in-one both low-level and high-level driver. 
I take it that there is not ever going to be a different high-level driver 
using low-level hv transport (is that correct, KY?), so this might indeed 
be an acceptable layout of the driver.

Thanks a lot,

-- 
Jiri Kosina
SUSE Labs
