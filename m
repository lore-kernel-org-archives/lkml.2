Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1IBOzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 10:55:54 -0400
Received: from bulk1.smtp.messagingengine.com ([66.111.4.222]:49080 "EHLO
	bulk1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349Ab1IBOzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 10:55:52 -0400
X-Greylist: delayed 1080 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Sep 2011 10:55:52 EDT
X-Sasl-enc: sTN2z/OrVs8xGIDP0IrF9fvJQdihv3g1wiatp4Gqdnwk 1314974271
Subject: TFD_CANCEL_ON_SET race when making a wall clock
From: Colin Walters <walters@verbum.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 02 Sep 2011 10:37:12 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1314974233.30505.9.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So I was recently making GNOME use the new timerfd TFD_CANCEL_ON_SET so
we get woken up when the system clock changes.  It works generally well,
except Ryan Lortie pointed out a race condition in my use of
timerfd_settime() that I think anyone using it to make a wall clock
display might not realize at first:

https://bugzilla.gnome.org/show_bug.cgi?id=655129#c36

For the link-averse, basically the system clock can move backwards
between when the process gets the current time, and computes the wakeup
(typically for the next minute).

I was able to work around it in userspace with this patch:
http://bugzilla-attachments.gnome.org/attachment.cgi?id=195252
But it's clearly not what I'd call beautiful.

I don't see a nice way to handle this in the kernel given the current
API, but maybe someone else does?

TFD_CANCEL_ON_SET isn't documented in man-pages at all right now...maybe
this is just a useful note for a future patch to
man-pages/man2/timerfd_create.2.


