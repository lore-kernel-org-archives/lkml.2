Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277Ab1ESXuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:50:55 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:43580 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934202Ab1ESXuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:50:54 -0400
Date: Fri, 20 May 2011 01:50:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: select() on /dev/input/eventX not level-triggered?
Message-ID: <20110519235051.GA9782@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm debugging strange behaviour on /dev/input/eventX ... it seems that
select is not behaving level-triggered as it apparently should. I can
reproduce it when hitting windows & alt keys.

Now, I really should rewrite it into C, first, but perhaps someone has
an idea?

								Pavel

#!/usr/bin/python
# Thanks to mechomaniac.com
# GPLv2
# Copyright 2011 Pavel Machek

import struct
import time
import select
import os
import random

#
# format of the event structure (int, int, short, short, int)
inputEventFormat = 'iihhi'
inputEventSize = 16
file = open("/dev/input/event5", "rb") # standard binary file input
while 1:
  ( i, o, e ) = select.select( [file], [], [], 0.5 )
  if i == []:
    print "timeout event"
    continue
  event = file.read(inputEventSize)
  time.sleep(1)
  (time1, time2, type, code, value) = struct.unpack(inputEventFormat, event)
  print "type ", type, " code ", code, " value ", value

file.close()


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
