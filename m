Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052Ab2EXUhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:37:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758930Ab2EXUhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:37:02 -0400
Date: Thu, 24 May 2012 16:36:56 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: USB device PM oddity in 3.5
Message-ID: <20120524203655.GK1143@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm testing Linus' tree as the merge window happens, and I've hit an
issue with what I believe is USB device power management (or something)
that is causing my mouse and keyboard to become unresponsive.  After a
very short time of non-use, either device will cut out.  I can move the
mouse around but it doesn't relay to the screen and I noticed this is
because the laser is turned off.  If I click a button on it, it will
turn back on and function again until a small period of non-use.  The
keyboard exhibits similar behavior, "ignoring" the first few key strokes
until it wakes back up.

I found this thread:

http://thread.gmane.org/gmane.linux.usb.general/64292
and
http://marc.info/?t=133552726500001&r=1&w=2

which have similar symptoms, but the kernels I'm using have the
subsequent patches applied.  I'm doing a git bisect at the moment, with
72c04af as the starting good commit and 61011677 as the first bad.  I'll
let you know what comes of this, but I thought I'd mail about it now in
case anyone has any ideas.

josh
