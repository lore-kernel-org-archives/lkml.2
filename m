Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab2IEAB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:01:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57280 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab2IEABY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:01:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Chris Zankel <chris@zankel.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/3] Turn CONFIG_HOTPLUG always on.
Date: Tue,  4 Sep 2012 17:01:05 -0700
Message-Id: <20120904234803.554552301@clark.kroah.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

The CONFIG_HOTPLUG variable is tough to turn off, and almost all arches
default to it on.

If you turn it off, it saves you a big 200 or so bytes, and then starts
to cause all sorts of problems as the code paths if the option is
disabled is never really tested, and memory segments start to get thrown
away that driver authors assume will always be present.

So, as part of trying to get rid of the option entirely, let's just turn
the option always on.

Note, to do this properly, I found two duplicate definitions of the
option, in the Tile and Xtensa arch files, this patch series removes
those duplicates first.

Anyone object to me just taking these three patches through my
driver-core tree for 3.7?  After this set, I'll start unwinding the
places where CONFIG_HOTPLUG is used and remove the parts that are not
used anymore now that the option can not be turned off.

thanks,

greg k-h

