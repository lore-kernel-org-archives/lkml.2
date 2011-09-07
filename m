Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab1IGAPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 20:15:48 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:29119 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab1IGAPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 20:15:42 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1315354539!14489106!2
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <greg@kroah.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "mchehab@redhat.com" <mchehab@redhat.com>
Date: Tue, 6 Sep 2011 19:15:38 -0500
Subject: RE: [PATCH] Staging: dt3155v4l: Convert printk's to pr_<level>
Thread-Topic: [PATCH] Staging: dt3155v4l: Convert printk's to pr_<level>
Thread-Index: Acxs8EqhIqYvS+KpQ4mL0qahiAaugAAAc12w
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F39D748D0C@AUSP01VMBX24.collaborationhost.net>
References: <201109011653.56089.hartleys@visionengravers.com>
 <20110906235253.GC26281@kroah.com>
In-Reply-To: <20110906235253.GC26281@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 06, 2011 4:53 PM, Greg KH wrote:
> On Thu, Sep 01, 2011 at 04:53:55PM -0700, H Hartley Sweeten wrote:
>> Convert all the printk(KERN_<level>) messages in the driver to pr_<level>()
>> and use pr_fmt to provide the module name.
>
> What's wrong with using dev_* instead of pr_*?  Lots of these should be
> converted to that format instead, right?

Nothing... dev_* should be used when possible.

Actually all of the messages look like they are just plain noise and should
be removed.  Especially the ones in dt3155_{init,exit}_module.  A lot of the
ones in dt3155_probe look like noise also.

The ones in {read,write,wait}_i2c_reg just look messy.  Those functions also
don't have a device pointer to use the dev_* functions.

The ones in dt3155_irq_handler seem troublesome.  Isn't it a bad idea to output
a kernel message in an interrupt handler?

dt3155_{open,close} also look like noise.  Same with dt3155_init_board.

Maybe I should just submit a patch removing all of them?

Regards,
Hartley
