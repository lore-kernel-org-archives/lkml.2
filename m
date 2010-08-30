Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab0H3QRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:17:45 -0400
Received: from claw.goop.org ([74.207.240.146]:54424 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab0H3QRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:17:44 -0400
Message-ID: <4C7BD9A6.1090108@goop.org>
Date: Mon, 30 Aug 2010 09:17:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Hank Janssen <hjanssen@microsoft.com>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>
Subject: Re: hv block drivers
References: <201008301643.42253.arnd@arndb.de>
In-Reply-To: <201008301643.42253.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 08/30/2010 07:43 AM, Arnd Bergmann wrote:
> Hi Hank,
>
> I wanted to follow up on the block device driver discussion we had at
> LinuxCon, based on some other input I got.
>
> What most people recommended was to make both the hv scsi and the
> hv ata code scsi device drivers, *not* make them standalone block
> drivers as I originally recommended.
>
> The main reason for this is consistent naming of the devices. We
> have a lot of user code that can deal with /dev/sd* devices, but
> introducing the /dev/vd* devices for virtio caused a lot of pain
> that you probably shouldn't have to go through.

We're having the same kind of problem with the Xen xvdX device naming. 
For a fully PV system it doesn't matter to much, but when you've got PV
drivers taking the place of a regular emulated hardware device it would
be nice to have a similar device name.

But there isn't a lot of similarity between the Xen block interface and
SCSI beyond the basic block transfer bits, so I was wondering how good a
match it would really be.

Have you investigated making virtio a scsi device?

    J
