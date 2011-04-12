Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab1DLOOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:14:37 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:56659 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755243Ab1DLOOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:14:35 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-03.arcor-online.net 73A67D869E
Subject: Re: [PATCH] HID: roccat: fixing actual/startup profile sysfs
 attribute in koneplus
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1104121326290.12035@pobox.suse.cz>
References: <1302444165.12514.2.camel@neuromancer>
	 <alpine.LNX.2.00.1104121326290.12035@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 16:14:31 +0200
Message-ID: <1302617671.2238.42.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 12.04.2011, 13:27 +0200 schrieb Jiri Kosina:
On Sun, 10 Apr 2011, Stefan Achatz wrote:
> 
> > startup_profile and actual_profile didn't work as expected. Also
> > as the actual profile is persistent, the distinction between the
> > two was ambiguous. And the event is now propagated through chardev.
> > The userland tool has been updated to support this change.
> 
> Fortunately, this is 'testing' ABI. But still, I'd prefer to follow good 
> practices here, and minimize incompatible ABI changes.
> 
> Is the userspace tool able to handle the situations:
> 
> - too old tool running to kernel containing this patch
> - new tool running on older kernel
> 
> ?

Lets split this in the three possible actions, two of them broken in the
actual module code:

1 reading actual_profile: shows stale data.
2 reading startup_profile: ok.
3 writing startup_profile: does not work because of a wrong writelength:

> > -	return koneplus_send(usb_dev, KONEPLUS_USB_COMMAND_STARTUP_PROFILE,
> > -			&buf, sizeof(struct koneplus_profile_buttons));
> > +	return koneplus_send(usb_dev, KONEPLUS_USB_COMMAND_ACTUAL_PROFILE,
> > +			&buf, sizeof(struct koneplus_actual_profile));

My userspace tools are not in any distros package repository, I keep new
tools backward compatible and I do a rapid release approach.
With these points and the actual modules flaws it didn't make much sense
for me to keep startup_profile for compatibility, but I wouldn't
struggle against it. If you feel better with the compatibility approach,
I can have an updated patch ready within minutes on request.
Stefan

