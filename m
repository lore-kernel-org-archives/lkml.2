Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313Ab1CDVqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:46:40 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63790 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760290Ab1CDVqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:46:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sgVu1eGgjr3b8l/+HvcsQvdZz+WWNxf/v+tEBcBLa2L6GoRIvyDN/427+lqujR5VZ8
         sDWmkNVVgdhbrUEtof+xWzbHy+EwVgQfR4Y/OlIW79uyZXaxuUXJbh9S+TRifVSwXi9p
         HqUkhj0/SlNoOsRfUCQB6cYKGiE31GoiRa2XA=
Date: Sat, 5 Mar 2011 00:46:32 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] power: disable hibernation if module loading is
 disabled
Message-ID: <20110304214630.GA29883@albatros>
References: <1299255084-4390-1-git-send-email-segoon@openwall.com>
 <201103042142.09247.rjw@sisk.pl>
 <20110304211035.GA28842@albatros>
 <201103042221.02852.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103042221.02852.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 22:21 +0100, Rafael J. Wysocki wrote:
> On Friday, March 04, 2011, Vasiliy Kulikov wrote:
> > If modules_disabled is set to 1, then nobody, even full root may not write
> > to the kernel, right?  So, if something permits to indirectly pass
> > modules_disabled restriction, this is a bug.  Otherwise,
> > modules_disabled is confusing as it gives false sense of security.
> > 
> > -OR-
> > 
> > modules_disabled's documentation should be changed to note that it
> > doesn't prevent rootkit uploading, but only forbids modprob'ing modules
> > via the "official" init_module(2) gate, disallowing e.g. module autoloading.
> 
> Why not to change that documentation, then?

Because it's better to fix something (if it is possible, of course) than
simply documenting the bug.

> Also, please note that in order to "write" into memory using the hibernation
> interface you need to have write access to swap,

No, you may just "write the kernel" via write() /dev/snapshot, this is
the way uswsusp works.  I didn't check whether it really needs
temporary file to change the kernel memory or it may be done entirely
without disk iteraction.  This is irrelevant to modules_disabled policy
violation, though.

> which you can use to corrupt
> memory regardless of the modules_disabled setting AFAICS.

Please correct me if I'm wrong, but kernel memory is not swappable at
all and only userspace memory is written to the swap.  Root with
CAP_SYS_ADMIN already may do everything with all processes, so this is
not a threat.

If one may change kernel memory via swap then it is another problem with
modules_disabled.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
