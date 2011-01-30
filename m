Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1A3MiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 07:38:25 -0500
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:47048 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753744Ab1A3MiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 07:38:23 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-15.arcor-online.net 3D5831AB6F2
Subject: [PATCH 0/8] HID: roccat: Bugfixes, code deduplication, support for
 Kova[+], ioctl for chardev
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Weber <weber@corscience.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Jan 2011 13:38:17 +0100
Message-ID: <1296391097.2283.179.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains:

- new hid_erro macros are used instead of dev_err
- module hid-roccat-common begins to contain code
  duplicated in the roccat device drivers.
  This contains just 2 functions for now, but more
  will come in the near future.
- Support for Kova[+] was added.
- Roccat chardev was refactured to support only one
  report size per device which can be retreived
  with a new ioctl
- A bug was fixed where Kone[+] froze occasionally
  on initialization
- A NULL pointer dereference was fixed that occured
  when unloading the module while a device was
  still present
- A bug was fixed that prevented roccat chardev
  from removing devices from its list.

