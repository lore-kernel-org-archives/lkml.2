Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1KPWp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 17:45:27 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39854 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab1KPWpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 17:45:25 -0500
MIME-Version: 1.0
In-Reply-To: <20111116222028.GK8685@redhat.com>
References: <20111116211329.GA8328@www.outflux.net>
	<20111116222028.GK8685@redhat.com>
Date: Wed, 16 Nov 2011 14:45:24 -0800
Message-ID: <CA+8MBb+dEz+zOD_SsOYqV3z1O-H-Q8CRyr6gPU73S34xhxDWiQ@mail.gmail.com>
Subject: Re: [PATCH v2] pstore: pass allocated memory region back to caller
From: Tony Luck <tony.luck@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        Huang Ying <ying.huang@intel.com>, Mike Waychison <mikew@google.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 2:20 PM, Don Zickus <dzickus@redhat.com> wrote:
> This is an interesting approach.  But are we leaving psinfo data exposed
> when you have a reader and writer at the same time?

I look at this as the first step in separating the read & write paths.

I started out with the (good) idea that the back end should allocate & own
the buffer for the write path ... this means that the buffer is ready to use
when an oops/panic happens - which is obviously a bad time to need to
allocate memory :-)

Then I reused the same buffer for read - in hindsight this was not such a
good idea - it led to all the discussions we've had about how to guarantee
that the dmesg data gets saved on panic - even in the cases where we
can't get the locks (so proposals have been made to bust the locks).

So Kees' patch is the functional equivalent of busting the spinlock.

Next step would be to look at the back end drivers to see whether
they can handle a simultaneous read & write in a graceful way.

I've queued this for linux-next. Probably missed the snapshot today,
but I expect it should show up in next-20111118
