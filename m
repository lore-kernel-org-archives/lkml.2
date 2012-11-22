Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2KVTBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:01:09 -0500
Received: from brockman.in8.de ([85.214.220.56]:52334 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab2KVTBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:01:06 -0500
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Nov 2012 14:01:06 EST
Message-ID: <50AE0210.7010301@jan-o-sch.net>
Date: Thu, 22 Nov 2012 11:44:32 +0100
From: Jan Schmidt <list.lkml@jan-o-sch.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Kay Sievers <kay@vrfy.org>
Subject: /proc/kmsg giving eof on blocking read
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently debugging something in btrfs in good old printk style, generating
around 10MB/min. I'm seeing /proc/kmsg returning eof on a blocking read (and,
side note, syslog-ng won't reopen it, effectively stopping logging kernel
messages silently).

I'm using kernel 3.6.0+ from cmason's tree, which is Linux 3.6.0 (commit
a0d271cbfed1dd50278c6b06bead3d00ba0a88f9) plus the Btrfs code for 3.7 (commit
c37b2b6269ee4637fb7cdb5da0d1e47215d57ce2).

I suspect it has something to do with the data I'm passing to printk. It happens
anywhere from several times per second to once every twenty minutes.

As a workaround (and proof), I'm currently using:

# perl -we 'use Fcntl; sysopen(K, "/proc/kmsg", O_RDONLY) or die "open $!";
while (1) {while ($ret = sysread(K, $buf, 8192)) {print $buf} print STDERR
scalar(localtime(time)), " oops $ret\\n";}' >> /var/tmp/kern

-Jan
