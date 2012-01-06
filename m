Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab2AFTk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 14:40:58 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:54616 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755282Ab2AFTk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 14:40:57 -0500
X-Sasl-enc: osB9eby3ghp+H8NR2Ln8rgBAzdFl7YL8m1WIy/1isdcN 1325878856
Date: Fri, 6 Jan 2012 11:40:52 -0800
From: Greg KH <greg@kroah.com>
To: Frank Mandarino <fmandarino@endrelia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Russell King <linux@arm.linux.org.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Public ridicule due to sound/soc/soc-core.c abuse of the driver model
Message-ID: <20120106194052.GA7781@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank, Liam, and sound maintainers.

It was recently pointed out to me that the sound/soc/soc-core.c is
flagrantly abusing the driver model by providing "empty" release
functions, just to keep the kernel from complaining:

/* stop no dev release warning */
static void soc_ac97_device_release(struct device *dev){}

....

static void rtd_release(struct device *dev) {}


As per the documentation in the kernel tree[1], I now get to publicly
mock you for thinking you know better than the driver model.

Come on people, do you think that I wrote the code in the kernel that
produces those errors just for fun?  It was telling you to fix your code
by providing a function to free the structure that is being released,
not to try to trick the kernel because you think you know better.  The
kernel was trying to help you out here, to get the programming model
correct, in a place that was commonly misunderstood.

But, by you trying to be "smart", you just proved that your code was
incorrect and buggy.

Please fix this for the 3.3 kernel release.

Yes, I know it's been there for a number of years, but that still
doesn't make it correct.  Especially as stuff like this tends to get
cut-and-pasted over time.

thanks,

greg k-h

[1] Documentation/kobject.txt
