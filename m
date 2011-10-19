Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab1JSUUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 16:20:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4541 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab1JSUUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 16:20:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=Q9XZVK0H1tj/if6I0M8I2fjRCCI/9rS7XkO3AEgyGf41sNK/toNbB37gEYiPon4FA
	pvNhLD015aLW7OVDP3n2Q==
Date: Wed, 19 Oct 2011 13:20:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sam Tygier <samtygier@yahoo.co.uk>, Ike Panhc <ike.pan@canonical.com>,
        Matthew Garrett <mjg@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 3.1rc10 null pointer dereference
 ideapad_backlight_notify_power
In-Reply-To: <4E9EB1BC.9020709@yahoo.co.uk>
Message-ID: <alpine.DEB.2.00.1110191315320.2892@chino.kir.corp.google.com>
References: <4E9EB1BC.9020709@yahoo.co.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011, Sam Tygier wrote:

> In kernels 3.1rc9 and 3.1rc10 (from the ubuntu mainline repo) I get a crash
> when disabling and then enabling the screen backlight with the alt+f2 key on a
> lenovo ideapad S12 (intel version). The crash does not occur with 3.0 kernels
> in ubuntu.  I have not tested earlier 3.1 rcs.
> 
> The crash message scrolls to fast to see, it is not writen to a log, and i
> dont see it on a USB serial console (I may be doing something wrong, but I do
> see other messages during boot). I managed to get some photos of the message.
> interesting parts are:
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000008
> IP: [<f807b29e>]  ideapad_backlight_notify_power+0x2e/0x40 [ideapad_laptop]
> *pde = 00000000
> Oops: 0002 [#1] SMP
> 
> call trace functions:
> ideapad_acpi_notify
> acpi_device_notify
> acpi_ev_notify_dispach
> acpi_os_execute_deferred
> process_one_work
> ? acpi_os_wait_events_complete
> ????????? can't read this one
> kthread
> kthread_bind
> kernel_thread_helper
> 
> i put the photos at http://www.hep.manchester.ac.uk/u/sam/pub/ideapad/
> 
> if it would be helpfull, i could try a few more times for sharper photos.
> please let me know if there is any other useful information you need.
> 

Looks light it may be changed via the acpi video driver where ->blight is 
NULL.  Adding Ike and Matthew to the cc.
