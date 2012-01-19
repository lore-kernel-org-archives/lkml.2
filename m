Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab2ASRSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:18:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56441 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab2ASRSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:18:14 -0500
Date: Thu, 19 Jan 2012 11:18:08 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Dave Airlie <airlied@redhat.com>, Alex Deucher <alexander.deucher@amd.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: radeon issues on MacBook Pro 8,2
Message-ID: <20120119171808.GB23144@ubuntu-macmini>
Mail-Followup-To: Dave Airlie <airlied@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing several issues related to the radeon driver on a MacBook Pro
8,2 with the following graphics card:

  ATI Technologies Inc Whistler [AMD Radeon HD 6600M Series] [1002:6741]

All problems were observed when using kernel version 3.2.1. None are
seen when using fglrx.

 1. Excessive power draw. When using the radeon driver ACPI reports a
    power draw of about 30W on an idle desktop. Using fglrx brings this
    number down to 15W.

 2. Occasional long delays when suspending. When this happens I see
    messages like following in dmesg:

      [drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs aborting
      [drm:atom_execute_table_locked] *ERROR* atombios stuck executing D44E (len 62, WS 0, PS 0) @ 0xD46A

    Sometimes one of suspend or resume hangs completely, but I can't
    tell which and am not sure whether or not it's related. I'm also
    testing a Mac Mini with the exact same card which does not seem to
    suffer from this issue.

    I ran a bisections that identified f8d0edd (drm/radeon/kms: improve
    DP detect logic) as introducing problems with suspend, and reverting
    this patch on top of 3.2.1 does seem to eliminate both issues.

 3. When the LVDS panel is powered off and back on, the display
    flickers, as if the backlight is cycling rapidly between low and
    high brightness. If the panel is left on this effect gradually
    lessens and is eventually no longer noticable. This is not seen with
    fglrx.

Thanks,
Seth
