Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab0LTRXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:23:19 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:33921 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab0LTRXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:23:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tv74fM2MA3uvfHcUrTBYstcWOxXXp+UQh5jocVN5hZFEPjBlsUOiJU/xDAXB3zlQ0k
         jtAXIg/r/sxGeHeH/lHyheZGYfkd9of8LU/ZyJHbHanLADoSVWHtw6lNZ0613DEytnEq
         KyTQtEG7sIJ8jICHl0vTUcwCas6hqpbyC0PwM=
Date: Mon, 20 Dec 2010 18:22:28 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Michal Marek <mmarek@suse.cz>
Subject: Build regression: unknown option "visible"
Message-ID: <20101220172228.GA463@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After pulling latest git from Linus (v2.6.37-rc6-132-g55ec86f)
I can't compile it anymore:

[mafra@Pilar:linux-2.6]$ make -j2 O=/mnt/ext4/kernel-output/
  GEN     /mnt/ext4/kernel-output/Makefile
scripts/kconfig/conf --silentoldconfig Kconfig
drivers/i2c/algos/Kconfig:6: unknown option "visible"
drivers/media/common/tuners/Kconfig:48: unknown option "visible"
drivers/media/video/Kconfig:115: unknown option "visible"
drivers/media/dvb/frontends/Kconfig:16: unknown option "visible"
make[3]: *** [silentoldconfig] Fehler 1
make[2]: *** [silentoldconfig] Fehler 2

This was introduced by 37e3273ee52f ("media/video: convert Kconfig 
to use the menu's `visible' keyword"), but I did a quick search 
and apparently I am the only one with a broken build. 

In any case, that's a regression for me and therefore I'm reporting it.

I can test patches etc and provide more info if needed.
