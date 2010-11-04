Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab0KDDJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 23:09:32 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42523 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab0KDDJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 23:09:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=oi5jSOOLJ0bEcJQEdSKjqr3ho6DQI5QyC+i2IildAoVHHpKK7eaDvpIbpWcQSRg/Cj
         ANJJwYzUCZ+LAaZIL/f2yhseU7ZrTZsRTEbZGsRmkNqhitlxvGQOq8PFK3zzOzYnhRHw
         zXRmoA9zzPg16yHDMXZIKYfjxG1VWROIl4ejM=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesper Juhl <jj@chaosbits.net>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Add Kconfig option for default swappiness
In-Reply-To: <20101102140119.GA8294@localhost>
References: <1288668052-32036-1-git-send-email-bgamari.foss@gmail.com> <alpine.DEB.2.00.1011012030100.12298@chino.kir.corp.google.com> <87oca7evbo.fsf@gmail.com> <20101102140119.GA8294@localhost>
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Wed, 03 Nov 2010 23:09:27 -0400
Message-ID: <87aalpbx94.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Nov 2010 22:01:20 +0800, Wu Fengguang <fengguang.wu@intel.com> wrote:
> It's interesting to know what value you plan to use for your
> desktop/server systems and the rationals (is it based on any
> testing results?).

This is something that will likely require a great deal of research,
thinking, and testing. I wish I could give you a better answer at the
moment. I have read many opinions on this but have not seen enough
evidence to suggest specific values. In the desktop case, it seems clear
that the preferred value should be lower than the current default to
preserve interactive performance (long latencies due to swapping is
something that many desktop users complain about currently). I set
swappiness to 10 on my own machines machines with good results, but mine
is anything but a model case. I don't believe there is any direct need
to touch the server kernel swappiness at the moment.

> And why it's easier to do it in kernel (hope it's not because of
> trouble communicating with the user space packaging team).

Fear not, this is certainly not the case. We would simply like to be
able to keep this our kernel configuration self-contained. We already
have separate packages for various kernel flavors with their own
configurations. Allowing us to tune swappiness from the configuration
would keep things much cleaner.

The other option would be to drop a file in /etc/sysctl.d from the
kernel meta-package (e.g. linux-image-generic and
linux-image-server). However, it would make little sense to do this
without adding a dependency on procps to this package (although,
admittedly, procps is in the default installation) which we would rather
not do if possible. Furthermore, this spreads the kernel configuration
across the system. In sum, it seems that configuring the default in the
kernel itself is by far the most elegant way to proceed.

Cheers,

- Ben
