Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0K3LFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 06:05:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48553 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752228Ab0K3LFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 06:05:19 -0500
Date: Tue, 30 Nov 2010 11:05:17 +0000
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
Message-ID: <20101130110516.GB7403@rakim.wolfsonmicro.main>
References: <1290964687.3016.5.camel@realization>
 <Pine.LNX.4.64.1011281923440.5731@axis700.grange>
 <1291023297.3139.55.camel@realization>
 <20101129155122.GB30926@sirena.org.uk>
 <1291113923.3235.58.camel@realization>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291113923.3235.58.camel@realization>
X-Cookie: To teach is to learn.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 11:45:23AM +0100, Alberto Panizzo wrote:
> On lun, 2010-11-29 at 15:51 +0000, Mark Brown wrote:

> > Unless you're actively varying the voltages at runtime (as Guennadi
> > mentioned) I'd really expect the voltages to be handled by the regulator
> > constraints.

> This is sane thinking at a static board configuration. What if a single 
> board have different deploying schemas where two different cameras can 
> be placed on the same connector and these cameras have different voltage
> levels for core supply? This scenario will require two different 
> constraints chosen at compile time -> two different kernel binaries.
> Otherwise constraints will always pick the minimum level and maybe this 
> will not be enough.

The way I'd expect to see that handled is that the constraints would be
chosen when the module is detected, possibly by having a platform device
representing the assembly as a whole.  There was someone working with
plugin modules doing something along those lines.  I certainly wouldn't
expect the device itself to worry about this unless it was actively
doing something to manage the voltage.
