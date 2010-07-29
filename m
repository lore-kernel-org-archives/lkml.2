Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab0G2FOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 01:14:36 -0400
Received: from imr3.ericy.com ([198.24.6.13]:45819 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab0G2FOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 01:14:16 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Nick Cheng <nick.cheng@areca.com.tw>,
        James Smart <james.smart@emulex.com>,
        Alex Iannicelli <alex.iannicelli@emulex.com>,
        "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        Benjamin Thery <benjamin.thery@bull.net>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH 0/6] Remove owner field from sysfs attribute structure
Date: Wed, 28 Jul 2010 22:09:20 -0700
Message-ID: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following comment is found in include/linux/sysfs.h:

   /* FIXME
    * The *owner field is no longer used.
    * x86 tree has been cleaned up. The owner
    * attribute is still left for other arches.
    */

As it turns out, the *owner field is (again?) initialized in several modules,
suggesting that such initialization may be creeping back into the code.

This patch set removes the above comment, the *owner field, and each instance
in the code where it was found to be initialized.

Compiled with x86 allmodconfig as well as with all alpha, arm, mips, powerpc,
and sparc defconfig builds.

