Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab2JVJAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:00:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab2JVJA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:00:28 -0400
Date: Mon, 22 Oct 2012 11:00:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: Re: [PATCH 1/1] HID: microsoft, fix invalid rdesc for 3k kbd
In-Reply-To: <1350646126-28537-1-git-send-email-jslaby@suse.cz>
Message-ID: <alpine.LNX.2.00.1210221059360.12268@pobox.suse.cz>
References: <1350646126-28537-1-git-send-email-jslaby@suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012, Jiri Slaby wrote:

> Microsoft Digital Media Keyboard 3000 has two interfaces, and the
> second one has a report descriptor with a bug. The second collection
> says:
> 05 01 -- global; usage page -- 01 -- Generic Desktop Controls
> 09 80 -- local; usage -- 80 -- System Control
> a1 01 -- main; collection -- 01 -- application
> 
> 85 03 -- global; report ID -- 03
> 19 00 -- local; Usage Minimum -- 00
> 29 ff -- local; Usage Maximum -- ff
> 15 00 -- global; Logical Minimum -- 0
> 26 ff 00 -- global; Logical Maximum -- ff
> 81 00 -- main; input
> 
> c0 -- main; End Collection
> 
> I.e. it makes us think that there are all kinds of usages of system
> control. That the keyboard is a not only a keyboard, but also a
> joystick, mouse, gamepad, keypad, etc. The same as for the Wireless
> Desktop Receiver, this should be Physical Min/Max. So fix that
> appropriately.
> 
> References: https://bugzilla.novell.com/show_bug.cgi?id=776834
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Added CC to stable and applied, thanks.

-- 
Jiri Kosina
SUSE Labs
