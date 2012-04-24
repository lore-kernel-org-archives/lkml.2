Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2DXMhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:37:34 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:39529 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab2DXMhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:37:32 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiKZAKWdlk9V5qnhPGdsb2JhbABEiiqmKgSBEBkBAQEBHhkNJ4IKAQUnExwjEAgDDjgUJQoaiCa7HhOLDYVLYwSVeYYEjSY
X-IronPort-AV: E=Sophos;i="4.75,473,1330902000"; 
   d="scan'208";a="24449380"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 24 Apr 2012 14:41:13 +0200
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] hid: Scan the device for group info before adding it
Message-ID: <20120424124113.GA10055@polaris.bitmath.org>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
 <1335175627-2270-3-git-send-email-rydberg@euromail.se>
 <alpine.LNX.2.00.1204241430190.1856@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1204241430190.1856@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static int hid_scan_report(struct hid_device *hid)
> > +{
> > +	unsigned int page = 0, delim = 0;
> > +	__u8 *start = hid->dev_rdesc;
> > +	__u8 *end = start + hid->dev_rsize;
> 
> Where do these dev_rdesc and dev_rsize come from? Your patchset doesn't 
> seem to be changing the corresponding struct device members (which are 
> rdesc and rsize currently), right?

Those members are added in the enable-report-fixup-on-rebind patchset,
which this patchset builds on. I only sent that patchset once, to
avoid confusion. Maybe I created some instead. :-)

And yes, the scanning algorithms do not touch the rdesc/rsize
variables, nor the collection state. Those are handled upon attachment
of the driver.

Thanks,
Henrik
