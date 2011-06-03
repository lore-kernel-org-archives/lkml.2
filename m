Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab1FCSjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:39:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42524 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab1FCSji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:39:38 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: "Krishnamoorthy, Balaji T" <balajitk@ti.com>
Subject: Re: [PATCH 4/8] mfd: twl6040: Add initial support
Date: Fri, 3 Jun 2011 19:44:26 +0300
User-Agent: KMail/1.13.7 (Linux/2.6.39-gentoo; KDE/4.6.3; x86_64; ; )
Cc: "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>,
        Jorge Eduardo Candelaria <jorge.candelaria@ti.com>,
        Margarita Olaya Cabrera <magi.olaya@ti.com>
References: <1306927051-8937-1-git-send-email-peter.ujfalusi@ti.com> <1306927051-8937-5-git-send-email-peter.ujfalusi@ti.com> <BANLkTi=3Xw8Ti80oreBiN4_a-=ekDfFM6A@mail.gmail.com>
In-Reply-To: <BANLkTi=3Xw8Ti80oreBiN4_a-=ekDfFM6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106031944.26251.peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 June 2011 16:47:21 Krishnamoorthy, Balaji T wrote:
> > +int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg)
> > +{
> > +       int ret;
> > +       u8 val = 0;
> > +
> > +       mutex_lock(&twl6040->io_mutex);
> > +       ret = twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &val, reg);
> 
> Can this dependency on twl_i2c_[read/write] be removed,
> Since TWL6040 is a separate IC which can get its own i2c_client in
> twl6040-core.c and
> create its own mfd devices like vibra, audio-codec ... while creating
> twl6040-core.c

You are right, twl6040 is separate IC.
I'll take a look how it can be separated from the twl-core (twl6030).

Thanks for noticing this, 
Péter
