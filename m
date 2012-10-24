Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935362Ab2JXRfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:35:39 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:57871 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816Ab2JXRfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:35:38 -0400
Message-ID: <1351100146.25024.0.camel@gitbox>
Subject: Re: [PATCH v3] pwm: vt8500: Update vt8500 PWM driver support
From: Tony Prisk <linux@prisktech.co.nz>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 25 Oct 2012 06:35:46 +1300
In-Reply-To: <20121024054114.GA9787@avionic-0098.mockup.avionic-design.de>
References: <20121023221419.GA8501@avionic-0098.mockup.avionic-design.de>
	 <1351050418-23981-1-git-send-email-linux@prisktech.co.nz>
	 <20121024054114.GA9787@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 07:41 +0200, Thierry Reding wrote:
> On Wed, Oct 24, 2012 at 04:46:58PM +1300, Tony Prisk wrote:
> > This patch updates pwm-vt8500.c to support devicetree probing and
> > make use of the common clock subsystem.
> > 
> > A binding document describing the PWM controller found on
> > arch-vt8500 is also included.
> > 
> > Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> > ---
> > v2/v3:
> > Fix errors/coding style as pointed out by Thierry Reding.
> > 
> >  .../devicetree/bindings/pwm/vt8500-pwm.txt         |   17 ++++
> >  drivers/pwm/pwm-vt8500.c                           |   86 ++++++++++++++------
> >  2 files changed, 80 insertions(+), 23 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
> 
> Looking real good now. One last comment though and I think I'm ready to
> take this...
> 
> > +	err = clk_enable(vt8500->clk);
> > +	if (err < 0)
> > +		dev_err(chip->dev, "failed to enable clock\n");
> > +		return -EBUSY;
> > +	};
> 
> Why do you return EBUSY instead of err?

Because I didn't notice this when I 'fixed' it - I changed the other one
to return err/ret, missed this one. Will fix.
> 
> Thierry
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



