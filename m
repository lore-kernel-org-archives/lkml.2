Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0JMIYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 04:24:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53713 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753133Ab0JMIYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 04:24:17 -0400
Date: Wed, 13 Oct 2010 09:24:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Peter Hsiang <Peter.Hsiang@maxim-ic.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
Subject: Re: [PATCH] ASoC: Add max98088 CODEC driver
Message-ID: <20101013082414.GD6424@rakim.wolfsonmicro.main>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
 <B2150E1E4418E1438554A300EA5040E40D469C124F@ITSVLEX06.it.maxim-ic.internal>
 <1286934472.1117.129.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286934472.1117.129.camel@Joe-Laptop>
X-Cookie: 667:
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 06:47:52PM -0700, Joe Perches wrote:
> On Tue, 2010-10-12 at 18:20 -0700, Peter Hsiang wrote:

> > +static struct {
> > +       int readable;
> > +       int writable;
> > +       int vol;
> > +} max98088_access[M98088_REG_CNT] = {

> bool instead?

> static struct {
> 	bool readable;
> 	bool writable,
> 	bool vol;
> } etc...

The readable and writable fields are being used as bitmasks:

| +       { 0x1F, 0x1F, 1 }, /* 03 battery voltage */

so this discards data which we may wish to use in future.

> readable isn't used anywhere, writeable is used as bool
> vol isn't a good name as it's easy to confuse with
> volume.  Maybe volatile_register?

vol is traditionally used for this throughout the subsystem.  It's
unfortuante that volatile is a keyword.
