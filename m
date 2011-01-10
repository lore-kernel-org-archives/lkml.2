Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab1AJFW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 00:22:28 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52109 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab1AJFW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 00:22:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=C5Si4dbmuI381o3D7NkCud0kInQm+ro+YW8JPVBMs4Mr/Utx4G044u1ims9sHuo3K9
         zuQK+ZQehS4Akw+Vr2dQP+ME7zu+7mxLmst2iH0H/hTftZjISrU6kZkd1F7YUA+KgfnX
         hBFHr69hrxGqeVKUitYBxCZVaExUgJDoRoA8k=
MIME-Version: 1.0
Date: Mon, 10 Jan 2011 08:22:25 +0300
Message-ID: <AANLkTimwDpUz9GUmx3UutYir0UuoTSAXNzphWeEX9sKh@mail.gmail.com>
Subject: ext3: deleting files doesn't free up space
From: Dan Carpenter <error27@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I filled up my partition last night.
I deleted 5 gigs of movies.
The "Used" number went down to 125G.
The "Free" number stayed at 0.
I rebooted the system but it's still the same.

$ echo foo > foo
bash: echo: write error: No space left on device

$ df .
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda1            136236548 130363620         0 100% /media/old_sys

$ mount | grep old
/dev/sda1 on /media/old_sys type ext3 (rw,nosuid,nodev)
/media/old_sys/home on /home type none (rw,bind)

This is with 2.6.37-rc5+.  Is there a way to debug this?

regards,
dan carpenter
