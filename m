Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2DVV1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 17:27:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab2DVV1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 17:27:09 -0400
Date: Sun, 22 Apr 2012 23:27:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nikolai Kondrashov <spbnick@gmail.com>
Subject: Re: [PATCH 0/3] hid: Enable report fixup on rebind
In-Reply-To: <1335097300-11881-1-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1204222325380.1856@pobox.suse.cz>
References: <1335097300-11881-1-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2012, Henrik Rydberg wrote:

> This patchset contains a resolution to the problem with
> driver-specific modification of the report descriptor. The core of the
> problem lies with the dual semantics of hid_parse_report(), which is
> therefore split into two functions. As a consequence, the hid core can
> handle the rebind case internally, with no changes to the
> drivers. Out-of-tree drivers will work fine as long as they operate in
> the same way as the in-kernel drivers.
> 
> The first two patches are bug fixes found in the process. I am hoping
> for some test feedback on those. The third patch is the main one.

Hi Henrik,

thanks a lot for looking into this. I will look into the patches in more 
detail tomorrow. I am now just adding Nikolai to CC, as he was the first 
one to bring this up and actually has a driver that exposed the fact that 
just freeing/reinstatiating rdesc is not enough.

Thanks!

> 
> Henrik Rydberg (3):
>   hid-hyperv: Do not use hid_parse_report() directly
>   hid-logitech: Collect report descriptors before sending
>   hid: Handle driver-specific device descriptor in core
> 
>  drivers/hid/hid-core.c        |  112 +++++++++++++++++++++++++++++++++--------
>  drivers/hid/hid-hyperv.c      |   14 +++++-
>  drivers/hid/hid-logitech-dj.c |   71 +++++++++++---------------
>  include/linux/hid.h           |   14 ++----
>  4 files changed, 135 insertions(+), 76 deletions(-)
> 
> -- 
> 1.7.10
> 

-- 
Jiri Kosina
SUSE Labs
