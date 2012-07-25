Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab2GYMu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:50:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57746 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917Ab2GYMuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:50:23 -0400
MIME-Version: 1.0
In-Reply-To: <2841959.DtLAQqdt31@linux-lqwf.site>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<CA+55aFypmnk8S4JkLui1Z7JxKae=-k88K-wEP9xDwrf1LOX-Vw@mail.gmail.com>
	<CACVXFVOiXRiqRsE46_xmOzK_dExNvkBaJVwjiZ9adhwqRRwY+g@mail.gmail.com>
	<2841959.DtLAQqdt31@linux-lqwf.site>
Date: Wed, 25 Jul 2012 20:50:20 +0800
Message-ID: <CACVXFVN8Zwk09m8ryZ4G8+ya24PjOw=sfrjhH_jbUkg9REY+0w@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] firmware loader: introduce cache/uncache firmware
From: Ming Lei <ming.lei@canonical.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 8:43 PM, Oliver Neukum <oneukum@suse.de> wrote:
> This is likely unwise. You'd better introduce a special flag for kernel threads
> that should be thawed only after user space will have been thawed.

IMO, it is not necessary to introduce one extra flag for the purpose since

     - usermodehelper flag should be set/get as enabled after user space
       tasks have been waken up

     - no harm to thaw all user space tasks before thawing all kernel threads
     (there isn't any dependency about the thawing order)

Thanks,
--
Ming Lei
