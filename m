Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab2DGWDq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 18:03:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53951 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab2DGWDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 18:03:45 -0400
Message-ID: <4F80B9AC.2010103@zytor.com>
Date: Sat, 07 Apr 2012 15:03:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Greg Kroah-Hartman <gregkh@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
References: <4F80892A.7050104@zytor.com> <20120407202056.472d8ad9@pyramind.ukuu.org.uk> <da8cd76d-6116-44a9-a7b3-7a501cb3a8a9@email.android.com> <20120407212705.GD11295@thunk.org>
In-Reply-To: <20120407212705.GD11295@thunk.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2012 02:27 PM, Ted Ts'o wrote:
> On Sat, Apr 07, 2012 at 01:02:33PM -0700, H. Peter Anvin wrote:
>> The problem is that the lack of migration at the root causes real
>> problems for the people who need the extra funkiness, and unlike BSD
>> ttys it's not an application-level change at all.
> 
> Could you explain what the issues are?  I haven't been following
> devpts all that carefully.
> 

The issue is that to make the "ptys are private to an instance of the
devpts filesystem", /dev/ptmx has to live inside the /dev/pts
filesystem.  This was traditionally not the case.  To avoid breaking
everything all at once, we have a legacy mode which supports the "all
devpts instances are the same" (effectively bind mounts) and which
support a /dev/ptmx outside /dev/pts.

The problem is that anyone who wants to take advantage of the new
functionality has to make sure *all* instances of devpts work with the
new protocol.  This means modifying your distro to:

1. Add "newinstance" and "ptmxmode" to /etc/fstab [easy]
2. Make /dev/ptmx a symlink to /dev/pts/ptmx.

2 would be easy if it wasn't for udev, which makes it very hard.  It is
not reasonable for udev to support both modes, so the *only* mode that
is reasonable for it to support is the new mode.  However, it is
increasingly obvious that if we don't force it, this will never happen.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

