Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab0FITvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:51:03 -0400
Received: from mail-yw0-f204.google.com ([209.85.211.204]:48778 "EHLO
	mail-yw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220Ab0FITvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:51:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type;
        b=io2xDb9HgVe95xg5t0xZy+4tZO81VjZ2NNLPns1Lbq2MD9aD4cX8OqwbIDwzWcJz8G
         f4GrU5Wh492EqxT/TRMQTdeXpw9q6cno2gndYaLAvILvtgT6sohgeufiGXPzTRiQ+5ja
         kctmnt/ZixdiQLgN+C7bp7bb+Tn0F8e+NgmPU=
MIME-Version: 1.0
From: Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>
Date: Wed, 9 Jun 2010 12:50:39 -0700
X-Google-Sender-Auth: C5YOPzsrcYto0SO3xDGybGXhKQo
Message-ID: <AANLkTinIO5a1EeK6Ej2ljkuyL9zv06OMfbyiZBaxTQTd@mail.gmail.com>
Subject: Timekeeping issue on aggressive suspend/resume
To: linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an application (running on 2.6.29-omap1) which puts an OMAP1
system to suspend aggressively. The system wakes up every 4 seconds
and stays awake for about 35 milliseconds and sleeps again for another
4 seconds. This design is to save power on a battery operated device.

This aggressive suspend resume action seems like creating an issue to
other applications in the system waiting for some timeout to happen
(especially an application which is waiting using the mq_timedreceive
and is supposed to timeout every 30 seconds. It seems to wake up every
90 seconds). Seems like the timekeeping is not happening properly in
side the kernel.

If the suspend duration is changed from 4 second to 1 second, then
things work somewhat better. On reducing it to 0.5 second (which was
our earlier design on 2.6.16-rc3), the problem seems to disappear.

Is this expected?

Thanks in advance,

Suresh
