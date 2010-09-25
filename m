Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0IYERL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 00:17:11 -0400
Received: from crca.org.au ([74.207.252.120]:51070 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab0IYERJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 00:17:09 -0400
X-Bogosity: Ham, spamicity=0.159565
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Nigel's current for-rafael queue
Date: Sat, 25 Sep 2010 14:16:42 +1000
Message-Id: <1285388224-10012-1-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael.

Please find attached a slightly updated version of the patchset I sent
a few months ago. The main change is that I've prepended and additional
patch which lets the user see the speed at which the image is being
read and written. This is accomplished by recording the MB/s in a single
byte in the image header, and using a couple of __nosavedata variables
to get the data back through the atomic restore. I realise the char limits
us to 255MB/s at the moment. In future patches, I intend to address this
by storing the data in a 'proper' image header (it's a real problem -
TuxOnIce reads and writes on the same set up at speeds around 250MB/s).

Results on my Dell XPS M1530, which has an SSD hard drive are:

With just patch 1 applied:
Attempt 1: Write 74MB/s; Read 52MB/s
Attempt 2: Write 68MB/s; Read 52MB/s
Attempt 3: Write 73MB/s; Read 53MB/s

With the whole sequence:
Attempt 1: Write 181MB/s; Read 52MB/s
Attempt 2: Write 156MB/s; Read 53MB/s
Attempt 3: Write 160MB/s; Read 52MB/s

Regards,

Nigel

