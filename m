Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab1FCMrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 08:47:23 -0400
Received: from canardo.mork.no ([148.122.252.1]:35673 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1FCMrU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 08:47:20 -0400
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jun 2011 08:47:20 EDT
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Oliver Neukum <oneukum@suse.de>
Cc: Alexey ORISHKO <alexey.orishko@stericsson.com>,
        "Valdis.Kletnieks\@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Dan Williams <dcbw@redhat.com>, Stefan Metzmacher <metze@samba.org>,
        Oliver Neukum <oliver@neukum.name>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] TODO FLAG_POINTTOPOINT => FLAG_WWAN? usbnet/cdc_ncm: mark ncm devices as "mobile broadband devices" with FLAG_WWAN
Organization: m
References: <1306922913-17803-1-git-send-email-metze@samba.org>
	<201106031201.21933.oneukum@suse.de>
	<2AC7D4AD8BA1C640B4C60C61C8E520153E3C13B620@EXDCVYMBSTM006.EQ1STM.local>
	<201106031250.28041.oneukum@suse.de>
Date: Fri, 03 Jun 2011 14:31:18 +0200
In-Reply-To: <201106031250.28041.oneukum@suse.de> (Oliver Neukum's message of
	"Fri, 3 Jun 2011 12:50:27 +0200")
Message-ID: <87sjrrxfjd.fsf@nemi.mork.no>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum <oneukum@suse.de> writes:

> Well, but cdc-ether usually means that you can start up dhcp and use the
> interface as a network card. Can the same be done with cdc-ncm or do you always
> need to establish a connection through a secondary interface?

Is there anything in the class definition that prevents either option,
for either protocol? No?

So, could we please kill the device guessing game?  Making decisions
based on absolute measures like "do we have a global mac address?" do
make some sense.  But guessing based on USB class does not.  That will
only tell you the protocol for the USB link. If you want more specific
device information, then you will have to look at the vid/pid. And I
assume you don't want to put all of those into the kernel when a class
driver will do, and whatever additional device specific information just
as well can be added by udev rules. Preferably created by whatever
application wishing to support the device.

But I do also assume you know all this already...



Bjørn
