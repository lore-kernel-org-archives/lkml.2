Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab1AGV7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 16:59:33 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39058 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab1AGV72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 16:59:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=taag1a0S8WGKVZJAGQOytZkCR47JrpPM8pjt7e5rOyF8wX5VR8QpaD6v+rP0nLhWb2
         oRh1lmFJZXHOoTRmjrQ4G5n55NoSb4dCFpmlIwqNtqcfMrcPSYpebJLAzn3dxsWPAeud
         iw2uhUWAYewF7VeBUnSz8kEeeaxVoW+bXIH50=
MIME-Version: 1.0
In-Reply-To: <4D2777FC.6040509@gmail.com>
References: <4D25AF02.60208@gmail.com>
	<AANLkTimGt5hi+TpFHWxktJEg3tcDQmmARdqFqzAt++OQ@mail.gmail.com>
	<4D2777FC.6040509@gmail.com>
Date: Fri, 7 Jan 2011 13:59:27 -0800
X-Google-Sender-Auth: zr4xxySgakNnr-Pucqi56wt9m3A
Message-ID: <AANLkTimtvYfHXG=rMLbFLzVaKbfB6nrj_ZE1AH4quRG2@mail.gmail.com>
Subject: Re: [PATCH 01/17] pramfs: documentation
From: Tony Luck <tony.luck@intel.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 12:30 PM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> constraint). About the errors: pramfs does not maintain file data in the
> page caches for normal file I/O, so no writeback, the read/write
> operation are done with direct io and they are always sync. The data are
> write protected in hw when the arch provide this facility (x86 does).
> Inode contains a checksum and when there are problems they are marked as
> bad. Superblock contains checksum and there is a redundant superblock.

But you can still get pramfs inconsistencies if the system crashes at an
inopportune moment. E.g. when making files you write the new inode to
pramfs, and then you insert the entry into the directory. A crash between
these two operations leaves an allocated inode that doesn't appear in
any directory.  Without a fsck option, it will be hard to see that you have
this problem, and your only recovery option is to wipe *all* files by making
a new filesystem.

-Tony
