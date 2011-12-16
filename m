Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550Ab1LPTM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:12:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab1LPTMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:12:24 -0500
Date: Fri, 16 Dec 2011 19:12:10 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: alsa-devel@alsa-project.org, Tom Walder <tom.walder@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] Jabra SPEAK 410 USB - no audio playback
Message-ID: <20111216191210.GI2520@amd.home.annexia.org>
References: <20111210142419.GC16692@amd.home.annexia.org>
 <20111210194539.GF16692@amd.home.annexia.org>
 <4EEB4C51.4010205@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEB4C51.4010205@ladisch.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 02:49:05PM +0100, Clemens Ladisch wrote:
> Richard W.M. Jones wrote:
> > The attached patch fixes USB audio support for the Jabra SPEAK 410 USB.
> >
> > The problem, as I understand it, is that the device contains a
> > Class-Specific Endpoint (CS_ENDPOINT) descriptor before the Endpoint
> > (ENDPOINT) descriptor.  The USB code all assumes that CS_ENDPOINT can
> > only appear after ENDPOINT.  Therefore the USB code divides up the
> > interface descriptor into "stuff before ENDPOINT" (in
> > interface->extra) and "stuff after ENDPOINT" (in
> > interface->endpoint[0]->extra).  For this device, this division does
> > not work.
> >
> > The solution (which is a hack ...) is to also search interface->extra
> > looking for the missing descriptor.
> 
> The patch looks good.  Please run it through checkpatch.pl and provice
> a Signed-off-by tag (see Documentation/SubmittingPatches).

Sorry, I should have followed up on this list ...

Tom (in the CC line) opened a bug with Jabra, and they have issued a
firmware update.  Unfortunately this update requires some Windows
software to run.  I applied this, and it does appear to fix the audio
playback problem, though curiously it doesn't completely fix the
ENDPOINT/CS_ENDPOINT problem, so who knows what's really going on
there.

Anyway, should you want the update it is here:

https://bugzilla.redhat.com/show_bug.cgi?id=766714#c1

Thanks Tom!

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://et.redhat.com/~rjones/virt-df/
