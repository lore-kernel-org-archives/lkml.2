Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934273Ab0EZGz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 02:55:29 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:41217 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934124Ab0EZGz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 02:55:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=ELJXWaVKzl4+bZJpoqR/wCErQde/O9eA20CSNY9hv/kIoU2zWcphOwNmwB3G6DwFq3
         BQo7JNzr9GqpbvxwTyuVGqoGSWAmJ+XvMzLDUAxT/O1+9OBdCktlL37RwwXxpWmOczF+
         0wgBsms7zkBZIIdyjkfmk+E//oSTVbFLiSMEI=
MIME-Version: 1.0
From: Frank Pan <frankpzh@gmail.com>
Date: Wed, 26 May 2010 14:55:04 +0800
Message-ID: <AANLkTikBrXROMvNKrhgxQ1jVh6aOsx3nIrNXTznXInV1@mail.gmail.com>
Subject: [PATCH 0/2] Enlarge the storage of chars in virtual terminal
To: Alan Cox <alan@linux.intel.com>,
       Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Daniel Mack <daniel@caiaq.de>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, Jochen Hein <jochen@jochen.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Dave Airlie <airlied@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings

The motivation is display much more characters on the
framebuffer console than 512. If this is done, foreign
languages can be easily rendered with currently supported
utf-8 encoding.

In order to display fonts with more than 512 chars,
the storage of one char in virtual terminal must be
enlarged. Currently vt holds one u16 for every character,
7 bits for attributes. The patches extend it into u32.

Virtual terminal is referenced by many other drivers.
If it has been changed, others must be changed as well.
Change all of them may spend 1 or more weeks, and the
patches include the change of fbcon. So I just put the
done part here and wish to have your advices.

Any reply is appreciated, thank you.

Frank Pan

 drivers/char/selection.c        |   26 ++--
 drivers/char/vc_screen.c        |    8 +-
 drivers/char/vt.c               |  250 ++++++++++++++++++++------------------
 drivers/video/console/bitblit.c |   33 +++--
 drivers/video/console/fbcon.c   |  256 ++++++++++++++++++++-------------------
 drivers/video/console/fbcon.h   |   16 ++--
 include/linux/console.h         |    8 +-
 include/linux/console_struct.h  |    8 +-
 include/linux/selection.h       |    6 +-
 include/linux/vt_buffer.h       |   15 ++-
 10 files changed, 327 insertions(+), 299 deletions(-)
