Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab1CRWAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:00:52 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43893 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859Ab1CRWAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:00:41 -0400
Date: Fri, 18 Mar 2011 19:00:35 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Suspend/resume regression in Toshiba A11 since 2.6.34-rc4
Message-ID: <20110318220034.GA10162@herton-IdeaPad-Y430>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This regression is old, but discovered recently. Since 2.6.34-rc4,
a Toshiba Tecra A11 machine resumes without video for the first time.
Here is the strange thing reported, on the first suspend/resume, when
the machine wakes up the video is blank, but the machine is up (just the
screen is black). If you suspend again, on second resume the video comes
back normally.

Helping the reporter bisecting the problem, we narrowed down the bug to
this commit:

commit ac7729da880e742613129ee6dea0045328670d2d
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Apr 5 01:43:51 2010 +0200

    ACPI / PM: Move ACPI video resume to a PM notifier

And reverting this commit on 2.6.38 still made the problem go away.
Looking at the commit above I don't saw any problem, and perhaps we have
some bad bios here which by moving the resume of acpi video later
triggers this bug. Also strange that on second suspend/resume everything
is normal... (the regression here is just the video is blank on first
resume).

I asked the reporter to try to increase brightness logged in remotely
when the video is blank after first resume, but this didn't have any
effect.

This was reported in https://bugs.launchpad.net/bugs/719620 (if reading
I recommend to skip to comment #58 and later), I can't think of any
solution besides trying to move acpi video resume perhaps back and
depend on video device being resume first. I asked for more debugging
information but got nothing unfortunately which could diagnose better
this...

-- 
[]'s
Herton
