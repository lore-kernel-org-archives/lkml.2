Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0K2Pvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:51:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46386 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0K2Pvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:51:32 -0500
Date: Mon, 29 Nov 2010 15:51:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <damm@opensource.se>, M?rton N?meth <nm127@freemail.hu>,
        linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] soc_camera: Add the ability to bind regulators to
	soc_camedra devices
Message-ID: <20101129155122.GB30926@sirena.org.uk>
References: <1290964687.3016.5.camel@realization> <Pine.LNX.4.64.1011281923440.5731@axis700.grange> <1291023297.3139.55.camel@realization>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291023297.3139.55.camel@realization>
X-Cookie: f u cn rd ths, u r prbbly a lsy spllr.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 10:34:57AM +0100, Alberto Panizzo wrote:
> On dom, 2010-11-28 at 20:05 +0100, Guennadi Liakhovetski wrote:

> >  (2) would anyone really want to 
> > use several regulators for a camera sensor? If so, can it be the case, 
> > that, for example, the regulators have to be switched off in the reverse 
> > order to switching on? Or something else?

> Well, I'm working on the i.MX31 3 Stack board support and there are 2 
> regulators that powers the camera and if you consider the digital output
> that enable another supplier needed, the total regulators are three..
> So, yes a list of regulators is needed in this case, and Yes I did not 
> considered the order of enabling and disabling operations. Just because
> even the freescale drivers didn't.

> A practical general rule is to turn off switchers in the reverse order
> than the turning on one. And this can be easily implemented here.
> But as you rose the question, we can add priorities of turning on and 
> off.

If you use the regulator bulk API it'll reverse the ordering when doing
the power down (or should if it doesn't already).

> > > +static int soc_camera_power_set(struct soc_camera_device *icd,
> > > +				struct soc_camera_link *icl,
> > > +				int power_on)
> > > +{
> > > +	int ret, i;
> > > +
> > > +	for (i = 0; i < icd->num_soc_regulators; i++) {
> > > +		if (power_on) {
> > > +			ret = regulator_set_voltage(icd->soc_regulators[i],
> > > +				icl->soc_regulator_descs[i].value_on_min,
> > > +				icl->soc_regulator_descs[i].value_on_max);

Unless you're actively varying the voltages at runtime (as Guennadi
mentioned) I'd really expect the voltages to be handled by the regulator
constraints.
