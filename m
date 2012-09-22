Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2IVPVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 11:21:50 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44938 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2IVPVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 11:21:48 -0400
Date: Sat, 22 Sep 2012 16:21:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20120922152139.GA26808@srcf.ucam.org>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <87bogzm1en.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bogzm1en.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 03:55:28PM -0700, Eric W. Biederman wrote:

> 1) I don't see anything disabling kdb or kgdb.  If ever there
>    was a way to poke into the kernel and change things...

Is there any way to access them without having physical console access 
(either the system console or a serial console)? Physically-present 
attacks are kind of out of scope here.

> 2) You almost certainly want to disable module removal.  It is all to
>    easy to have races where that are not properly handled in the module
>    removal path.  I know I saw a bundle of those in debugfs the other
>    day.

I'm pretty reluctant to work around bugs like this. Disabling features 
certainly reduces the attack surface, but the aim is to only disable 
features that *by design* permit the modification of the kernel. Where 
it's possible to do so by exploiting bugs, we should be fixing the bugs.

> 3) And half seriously you probably want to disable mounting of
>    filesystems.  I believe I have heard it said the kernel has not been
>    vetted against a hostile root user mounting deliberately corrupted
>    filesystem images.

See (2). Not that you need to be root to trigger filesystem mounts, so 
this is also a user->kernel exploit. Those should be fixed.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
