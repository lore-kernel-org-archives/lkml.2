Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab1DUSTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:19:10 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:53242 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988Ab1DUSTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:19:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LCGVLdfJulTvSeHOiBvoBuXyNCC2lSG+gakXmYGSXuhbWOVuX2SaSOdUW3K0HJ76KO
         mI2p5cbcu/eSKI+IU7wGR50XMgwj9o1O4UZQ3NzQ3Q+iEQVreTmqlfKOqR4e9n3wV7pF
         /EzKr2SRWBWJLVXTmEhC6NSes5x9kNaHf6tRQ=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        James Nuss <jamesnuss@nanometrics.ca>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] davinci-mcasp: fix tdm_slots and CBM/CFS
Date: Thu, 21 Apr 2011 14:19:00 -0400
Message-Id: <cover.1303408522.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is comprised of three bugfixes and one cleanup that 
were performed during prototyping of McASP operation in codec clock-
master frame-slave mode.

First we noticed that the check of the number of tdm slots requested
by platform data was always returning true -- unrelated to CMB/CFS
mode.

Then a cleanup: the PDIR values set are currently based on magic 
numbers and there are  available bitfield definitions. Not strictly
needed but it makes the changes introduced in the last patch simpler
to read.

It was found that the hardware parameters assigned when 
codec clock-master frame-slave is requested were incorrect. This
change is required for correct CBM/CFS operation.

Finally, the direction of the pins is corrected to reflect the
implications of codec clock-master frame-slave -- i.e. mcasp clock-
input frame-output. This change is also required for correct operation.

The combination was tested with a logic analyzer and the hrtimer pwm
device from Bill Gatliff's PWM framework [1] on a da850evm with
hardware modifications to access the McASP lines.

[1] http://article.gmane.org/gmane.linux.kernel.embedded/3486/

Ben Gardiner (4):
  davinci-mcasp: correct tdm_slots limit
  davinci-mcasp: use bitfield definitions for PDIR
  davinci-mcasp: fix _CBM_CFS hw_params
  davinci-mcasp: fix _CBM_CFS pin directions

 sound/soc/davinci/davinci-mcasp.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

