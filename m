Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2KJEvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 23:51:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33977 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab2KJEvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 23:51:06 -0500
Date: Sat, 10 Nov 2012 04:51:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michel Lespinasse <walken@google.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: Issues with "x86, um: switch to generic fork/vfork/clone" commit
Message-ID: <20121110045104.GN2616@ZenIV.linux.org.uk>
References: <CANN689FmsFBjfiD8V-nQyDh+GtTF5B3SDUcuXc=3OeeN6JW0kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689FmsFBjfiD8V-nQyDh+GtTF5B3SDUcuXc=3OeeN6JW0kw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 08:36:53PM -0800, Michel Lespinasse wrote:
> Hi,
> 
> I'm having an issue booting current linux-next kernels on my test
> machines. Userspace crashes when it's supposed to pivot to the rootfs.
> With the loglevel=8 kernel parameter, the last messages I see are:
> 
> Checking root filesystem in pivot_root init.
> [    6.252717] usb 2-1: link qh256-0001/ffff880853ec9ab8 start 1 [1/0 us]
> [    6.259419] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0000
> [    6.292302] traps: hotplug[1633] general protection ip:f767c06b
> sp:ffbb2d1c error:0 in libc-2.3.6.so[f7652000+126000]
> 
> I ran a bisection and it turns out that
> e52d03a3775841cc68d0ea9d86f2f09b603c41e6 (x86, um: switch to generic
> fork/vfork/clone) is the commit breaking my setup. When reverting
> that, I am able to boot linux-next (or mmotm, which is what I was
> trying to do in the first place) without issues.
> 
> Sorry for not having a more complete root cause at the moment - I'm
> lacking some context as to what the change is trying to do.

Hmm...  32bit native, presumably?
