Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab2IGNJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:09:37 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:42031 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab2IGNJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:09:36 -0400
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Sep 2012 09:09:35 EDT
From: Krzysztof Halasa <khc@pm.waw.pl>
To: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: 3.4.10 N_GSM tty_io WARNING and lockup
References: <m3k3w8g2m4.fsf@t19.piap.pl>
	<20120906140137.75ebe6ba@pyramind.ukuu.org.uk>
	<m3627qt7kn.fsf@t19.piap.pl>
Date: Fri, 07 Sep 2012 14:59:26 +0200
In-Reply-To: <m3627qt7kn.fsf@t19.piap.pl> ("Krzysztof =?utf-8?Q?Ha=C5=82as?=
 =?utf-8?Q?a=22's?= message of
	"Fri, 07 Sep 2012 13:07:20 +0200")
Message-ID: <m3sjauc7kh.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In the meantime I've rebased to v3.5.3 and it started to work. Do you
> think it is worth it investigating v3.4.10 at this point?

BTW I'm not sure if it's a known bug: I closed the /dev/ttyS0 with
/dev/gsmmuxX still open, and then tried to set N_TTY ldisc on the
master device. It didn't work so well :-(

# killall -9 microcom	# they use /dev/gsmmux[0-3]
# killall -9 iru	# the program messing with ldiscs
# ps axf

  344 ?        Ss     0:00  \_ sshd: root@pts/1
  346 pts/1    Ss     0:00  |   \_ -sh
  405 pts/1    D+     0:00  |       \_ [microcom]
  347 ?        Ss     0:00  \_ sshd: root@pts/2
  349 pts/2    Ss     0:00  |   \_ -sh
  403 pts/2    D+     0:00  |       \_ [microcom]
  406 ?        Ss     0:00  \_ sshd: root@pts/3
  408 pts/3    Ss     0:00  |   \_ -sh
  412 pts/3    D+     0:00  |       \_ [microcom]
  409 ?        Ss     0:00  \_ sshd: root@pts/4
  411 pts/4    Ss     0:00      \_ -sh
  413 pts/4    D+     0:00          \_ [microcom]
  415 pts/0    D      0:00 iru
-- 
Krzysztof Halasa
