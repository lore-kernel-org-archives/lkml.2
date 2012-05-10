Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab2EJWbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:31:42 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:36464 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab2EJWbk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:31:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-127.messagelabs.com!1336689079!5169428!21
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
Date: Thu, 10 May 2012 17:31:36 -0500
Subject: RE: [PATCH v2] staging: comedi: refactor sysfs files in
 comedi_fops.c
Thread-Topic: [PATCH v2] staging: comedi: refactor sysfs files in
 comedi_fops.c
Thread-Index: Ac0uI9FZjsoNw5CHTpOqptGcSgWmhAA2KMuw
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698A17CD0@AUSP01VMBX24.collaborationhost.net>
References: <201205090920.09769.hartleys@visionengravers.com>
 <20120509203916.GA16972@kroah.com>
In-Reply-To: <20120509203916.GA16972@kroah.com>
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

On Wednesday, May 09, 2012 1:39 PM, Greg KH wrote:
> On Wed, May 09, 2012 at 09:20:08AM -0700, H Hartley Sweeten wrote:
>> Refactor the sysfs attributes and functions to remove
>> the need for the forward declarations and use the
>> DEVICE_ATTR macro to define them.
>> 
>> Instead of individually creating sysfs device attribute
>> files, wrap them in an attribute_group and use the
>> sysfs_create_group function to create them.
>
> This is great, and needed to be done, but you need to take this one step
> further.  This attribute group needs to be registered by the driver
> core, not the comedi core, so userspace doesn't get an add event before
> the files are created.  To do that, assign this attribute group to the
> class and the core will handle it for you.
>
> I've taken this patch, but will you make a follow-on patch that makes
> this change, which will remove this race?  It should be a net removal of
> code in the comedi core overall.
>
I think I worked this out. Compile testing it now and will post the patch
shortly.

Regards,
Hartley

