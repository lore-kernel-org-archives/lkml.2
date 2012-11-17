Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2KQEH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 23:07:26 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:51532 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab2KQEHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 23:07:25 -0500
Message-ID: <1353125259.18544.7.camel@gitbox>
Subject: pwm_backlight/general pwm issue.
From: Tony Prisk <linux@prisktech.co.nz>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Arm Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        VT8500 Mailing List 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Date: Sat, 17 Nov 2012 17:07:39 +1300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

Looking a little feedback regarding a problem introduced with the pwm
patch I sent converting the vt8500 pwm driver to devicetree.

One of the recommendations you made was to enable/disable the pwm clock
in pwm_enable/pwm_disable, rather than at driver probe, to reduce power
usage. Unfortunately, when the last pwm is disabled, the clock is
disabled which prevents the pwm module from responding to register
read/writes. This would be fine if pwm_enable was called before any
other functions.

The pwm_backlight driver calls pwm_config before pwm_enable, which
doesn't work because the pwm module has been disabled. I can appreciate
that no one wants to enable a pwm before it's configured so I don't
think this is particularly a driver issue.


My recommendation is the re-enable the previous behaviour which was to
enable the clock during driver probe, and disable during driver unload.

Looking for your thoughts (or anyone else that wants to chime in).

Regards
Tony Prisk

