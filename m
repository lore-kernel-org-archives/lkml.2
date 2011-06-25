Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab1FYFyy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 01:54:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62612 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1FYFyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 01:54:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=lxKxa9Or3nF7JiFeygDC+zOW+v49eq8P3QpXrZ+1Tc+tojs6zozFARRN7vfjER6g+r
         YeLtRfseoGfDeYiiLjnET98TAPEcsb03XqZZMFoOqFav6MJ3mnzFcg2w5l79MBukS9/k
         Wi6x/hF9irMj3qfp7oVnGlLTSf6lxXOKe64xc=
MIME-Version: 1.0
Date: Sat, 25 Jun 2011 13:51:07 +0800
Message-ID: <BANLkTinC7vfaRWf5TK9gJuQVtVwDkEQFcQ@mail.gmail.com>
Subject: random(4) driver questions
From: Sandy Harris <sandyinchina@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a paper some time back by a group of Israeli researchers
and looking at the Linux /dev/random driver, and claiming to find
it wanting in several ways. www.pinkas.net/PAPERS/gpr06.pdf

To what extent have their objections been dealt with. If some
were considered bogus, is there documentation somewhere
explaining why?

One problem they pointed out is that there may be little
entropy available on a Linux-based router; no keyboard or
mouse, solid state storage so no disk entropy, and an
enemy might observe network activity, so network
interrupts give little or no useful entropy.

The only in-kernel solution I can think of would be
to add something in the system call interface to
make very system call throw timing information
into the pool. I very much doubt, though, that that
is a good idea. What do others think, and does
anyone have a better idea?

What happens to /dev/random when it runs on
a virtual machine and all the things it relies on
for entropy get virtualised away?

The server that the VM is hosted on will usually
have plenty of entropy, often a hardware RNG.
Is there an interface that makes that visible
from the VM? Perhaps a virtual "hardware"
RNG driven by /dev/urandom on the host?
