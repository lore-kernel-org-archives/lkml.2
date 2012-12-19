Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab2LSM5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 07:57:36 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:59448 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab2LSM52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 07:57:28 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 5/5] Input: Add ChromeOS EC keyboard driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Simon Glass <sjg@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Luigi Semenzato <semenzato@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Olof Johansson <olof@lixom.net>, Roland Stigge <stigge@antcom.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
In-Reply-To: <2990462.l5jY89jKQx@dtor-d630.eng.vmware.com>
References: <1355348028-19017-1-git-send-email-sjg@chromium.org> <1355348028-19017-6-git-send-email-sjg@chromium.org> <20121215011345.9D5973E0BEE@localhost> <2990462.l5jY89jKQx@dtor-d630.eng.vmware.com>
Date: Wed, 19 Dec 2012 12:57:22 +0000
Message-Id: <20121219125722.DCD3E3E0AD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2012 17:43:31 -0800, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Saturday, December 15, 2012 01:13:45 AM Grant Likely wrote:
> > On Wed, 12 Dec 2012 13:33:48 -0800, Simon Glass <sjg@chromium.org> wrote:
> > > Use the key-matrix layer to interpret key scan information from the EC
> > > and inject input based on the FDT-supplied key map. This driver registers
> > > itself with the ChromeOS EC driver to perform communications.
> > > 
> > > Additional FDT bindings are provided to specify rows/columns and the
> > > auto-repeat information.
> > > 
> > > Signed-off-by: Simon Glass <sjg@chromium.org>
> > > Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
> > > Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> > > ---
> > > 
> > >  .../devicetree/bindings/input/cros-ec-keyb.txt     |   77 ++++
> > >  drivers/input/keyboard/Kconfig                     |   10 +
> > >  drivers/input/keyboard/Makefile                    |    1 +
> > >  drivers/input/keyboard/cros_ec_keyb.c              |  413
> > >  ++++++++++++++++++++ 4 files changed, 501 insertions(+), 0 deletions(-)
> > >  create mode 100644
> > >  Documentation/devicetree/bindings/input/cros-ec-keyb.txt
> > >  create mode 100644 drivers/input/keyboard/cros_ec_keyb.c
> > > 
> > > diff --git a/Documentation/devicetree/bindings/input/cros-ec-keyb.txt
> > > b/Documentation/devicetree/bindings/input/cros-ec-keyb.txt new file mode
> > > 100644
> > > index 0000000..67f51d8
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/input/cros-ec-keyb.txt
> > > @@ -0,0 +1,77 @@
> > > +ChromeOS EC Keyboard
> > > +
> > > +Google's ChromeOS EC Keyboard is a simple matrix keyboard implemented on
> > > +a separate EC (Embedded Controller) device. It provides a message for
> > > reading +key scans from the EC. These are then converted into keycodes
> > > for processing +by the kernel.
> > > +
> > > +Required properties:
> > > +- compatible: "google,cros-ec-keyb"
> > > +- google,key-rows: Number of keyboard rows (must be <= 8)
> > > +- google,key-columns: Number of keyboard columns (must be <= 13)
> > > +- google,repeat-delay-ms: Key repeat delay in milliseconds
> > > +- google,repeat-rate-ms: Key repeat rate in milliseconds
> > 
> > Hmmm, these should probably be in a common binding. Take a look at
> > the other input bindings and make a proposal for properties to add to
> > matrix-keymap.txt.
> 
> Actually these are not essentia for bringup and can be set from userspace,
> so I'd say simply drop them.

Aren't they needed for a working keyboard? If so, I would really think
they should be set correctly without userspace intervention.

g.

