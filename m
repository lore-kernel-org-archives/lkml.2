Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab2FSN0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 09:26:12 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:13531 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab2FSN0K convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 19 Jun 2012 09:26:10 -0400
Message-Id: <4FE09A3A020000780008A9D0@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 19 Jun 2012 14:26:50 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <rydberg@euromail.se>, "Jiri Kosina" <jkosina@suse.cz>
Cc: <linux-kernel@vger.kernel.org>
Subject: hid-generic regression on existing distros
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrik, Jiri,

commit 8215d557e5f3a70e50e07c857d35c250fee62a73 results
in no keyboard or mouse during early boot on systems where
those are USB-based and HID=m, since nothing there can
possibly be aware that this new driver needs to be manually
loaded for e.g. interactive startup mode to be useful, as it would
have to make it into initrd, yet the mkinitrd machinery can't
reasonably know of it.

Imo, with the functionality having been previously provided
by usbhid.ko, that module should cause hid-generic to be
pulled in automatically.

(Also, just as a side note, a Kconfig default of 'y' is pointless
for a tristate option that depends on another tristate one,
when that one was already set to 'm' - the default really
should be the value of the depended upon symbol.)

Jan

