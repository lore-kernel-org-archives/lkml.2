Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab0JANxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:53:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34337 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353Ab0JANw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:52:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lW7Mb8iGixD8sjBFsTEavNSjNUmMuWm3N53ykmaDUesI2iSFKKMwvDBDzl6YWhvgSa
         L+Veo+CzcRkH0cJIXYMNV76VtR2zkG9gZusXrek6bekG/9Ds017NyyXKu4iEgKJwzsbz
         Dy2zC0a5lqHfMcHffA7kgmbgY+HRG9yVyRchM=
Date: Fri, 1 Oct 2010 17:52:54 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] altera_uart: Make it possible to use Altera UART
 and 8250 ports together
Message-ID: <20101001135254.GA27739@oksana.dev.rtsoft.ru>
References: <20101001132045.GA9649@oksana.dev.rtsoft.ru>
 <20101001132207.GE25897@oksana.dev.rtsoft.ru>
 <20101001134138.5ea2fb55@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101001134138.5ea2fb55@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 01:41:38PM +0100, Alan Cox wrote:
> On Fri, 1 Oct 2010 17:22:07 +0400
> Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> 
> > This fixes tty name and major number conflicts. The major number
> > 204 is used across many platform-specific serial drivers, so we
> > use that.
> 
> 204 is allocated in small chunks to specific low volume devices so you
> need a proper minor allocation
> 
> At this point that would be 204,213 for whatever tiny range you need.
> 
> Please send me a patch for devices.txt and update accordingly,
> otherwise no objections.

Sure thing. Will this work?

Thanks!

- - -
From: Anton Vorontsov <cbouatmailru@gmail.com>
Subject: lanana: Assign a device name and numbering for Altera UART

Note that Altera UART is usually found on an FPGA solutions, so there
could be quite a lot of ports (expanded as needed).

I guess the sane maximum number of ports would be 8, but it is still
possible to do hundreds of them.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 Documentation/devices.txt |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index d0d1df6..984cf24 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -2805,6 +2805,9 @@ Your cooperation is appreciated.
 		 210 = /dev/ttyMAX1		MAX3100 serial port 1
 		 211 = /dev/ttyMAX2		MAX3100 serial port 2
 		 212 = /dev/ttyMAX3		MAX3100 serial port 3
+		 213 = /dev/ttyAL0		Altera UART port 0
+		    ...
+		 221 = /dev/ttyAL7		Altera UART port 7
 
 205 char	Low-density serial ports (alternate device)
 		  0 = /dev/culu0		Callout device for ttyLU0
-- 
1.7.0.5

