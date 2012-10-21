Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab2JUINf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 04:13:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40860 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab2JUINd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 04:13:33 -0400
Date: Sun, 21 Oct 2012 01:13:29 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/2] char_dev: allow setting up and pinning parent devices
Message-ID: <20121021081329.GA1959@core.coreip.homeip.net>
References: <20121019175046.GP2616@ZenIV.linux.org.uk>
 <1350804271-2449-1-git-send-email-dmitry.torokhov@gmail.com>
 <20121021073928.GV2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121021073928.GV2616@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 08:39:28AM +0100, Al Viro wrote:
> On Sun, Oct 21, 2012 at 12:24:30AM -0700, Dmitry Torokhov wrote:
> > In certain cases (for example when a cdev structure is embedded into
> > another object whose lifetime is controlled by a separate device object)
> > it is beneficial to tie lifetime of another struct device to the lifetime
> > of character device so that related object is not freed until after
> > char_dev object is freed. To achieve this allow setting a "parent" device
> > for character devices and pin them when doing cdev_add() and unpin when
> > last reference to cdev structure is being released.
> 
> Why struct device and not simply struct kobject?

It was more convenient for my uses and I also think that parents of
character devices will be struct devices... I however will not insist
and if you prefer using more generic kobject I can change it,

Thanks.

-- 
Dmitry
