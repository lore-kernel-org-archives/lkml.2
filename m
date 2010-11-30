Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab0K3Kpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 05:45:32 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55338 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab0K3Kpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 05:45:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pWgdriconbIwlO4kE2xkLnX4ICVMaR+3jdr2r17F9s0KkSoUxie8eaJ0nz85Lro7lI
         C0FMHmQbbczOD7Ii+ArDemJ7w1YAJ7luBuK7eDrWSf4F0KZ1HlxUap05M7F6+53yYJ0U
         EBfOM0TrfQjD+14nL/ZZwGJ6hrjbg4HuM5Qek=
Subject: Re: [PATCH 1/3] soc_camera: Add the ability to bind regulators to
 soc_camedra devices
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <damm@opensource.se>, M?rton N?meth <nm127@freemail.hu>,
        linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20101129155122.GB30926@sirena.org.uk>
References: <1290964687.3016.5.camel@realization>
	 <Pine.LNX.4.64.1011281923440.5731@axis700.grange>
	 <1291023297.3139.55.camel@realization>
	 <20101129155122.GB30926@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 11:45:23 +0100
Message-ID: <1291113923.3235.58.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On lun, 2010-11-29 at 15:51 +0000, Mark Brown wrote:
> On Mon, Nov 29, 2010 at 10:34:57AM +0100, Alberto Panizzo wrote:
> > On dom, 2010-11-28 at 20:05 +0100, Guennadi Liakhovetski wrote:
> 
> > >  (2) would anyone really want to 
> > > use several regulators for a camera sensor? If so, can it be the case, 
> > > that, for example, the regulators have to be switched off in the reverse 
> > > order to switching on? Or something else?
> 
> > Well, I'm working on the i.MX31 3 Stack board support and there are 2 
> > regulators that powers the camera and if you consider the digital output
> > that enable another supplier needed, the total regulators are three..
> > So, yes a list of regulators is needed in this case, and Yes I did not 
> > considered the order of enabling and disabling operations. Just because
> > even the freescale drivers didn't.
> 
> > A practical general rule is to turn off switchers in the reverse order
> > than the turning on one. And this can be easily implemented here.
> > But as you rose the question, we can add priorities of turning on and 
> > off.
> 
> If you use the regulator bulk API it'll reverse the ordering when doing
> the power down (or should if it doesn't already).

Great API regulator_bulk, let's get it a try! ..I was reinventing the 
hot water..

> 
> > > > +static int soc_camera_power_set(struct soc_camera_device *icd,
> > > > +				struct soc_camera_link *icl,
> > > > +				int power_on)
> > > > +{
> > > > +	int ret, i;
> > > > +
> > > > +	for (i = 0; i < icd->num_soc_regulators; i++) {
> > > > +		if (power_on) {
> > > > +			ret = regulator_set_voltage(icd->soc_regulators[i],
> > > > +				icl->soc_regulator_descs[i].value_on_min,
> > > > +				icl->soc_regulator_descs[i].value_on_max);
> 
> Unless you're actively varying the voltages at runtime (as Guennadi
> mentioned) I'd really expect the voltages to be handled by the regulator
> constraints.

This is sane thinking at a static board configuration. What if a single 
board have different deploying schemas where two different cameras can 
be placed on the same connector and these cameras have different voltage
levels for core supply? This scenario will require two different 
constraints chosen at compile time -> two different kernel binaries.
Otherwise constraints will always pick the minimum level and maybe this 
will not be enough.

Best regards,

-- 
Alberto!

        Be Persistent!
                - Greg Kroah-Hartman (FOSDEM 2010)

