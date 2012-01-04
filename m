Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab2ADXMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:12:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:35329 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177Ab2ADXMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:12:35 -0500
Message-ID: <1325718504.23910.11.camel@pasglop>
Subject: Re: [PATCH] fsl/mpic: Document and use the "big-endian" device-tree
 flag
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>, linuxppc-dev@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Jan 2012 10:08:24 +1100
In-Reply-To: <4F04DF50.4070201@xenotime.net>
References: <1324571123-11577-1-git-send-email-Kyle.D.Moffett@boeing.com>
	 <4F04DF50.4070201@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 15:22 -0800, Randy Dunlap wrote:
> On 12/22/2011 08:25 AM, Kyle Moffett wrote:
> > The MPIC code checks for a "big-endian" property and sets the flag
> > MPIC_BIG_ENDIAN if one is present.  Unfortunately, the PowerQUICC-III
> > compatible device-tree does not specify it, so all of the board ports
> > need to manually set that flag when calling mpic_alloc().
> > 
> > Document the flag and add it to the pq3 device tree.  Existing code
> > will still need to pass the MPIC_BIG_ENDIAN flag because their dtb may
> > not have this property, but new platforms shouldn't need to do so.
> > 
> > Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
> 
> Grant, are you merging this patch?
> I don't think I should merge the patch to arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi.

Best is to leave the whole lot to me. It's not like mpic is used
anywhere else ...

Cheers,
Ben.

> > --
> >  .../devicetree/bindings/powerpc/fsl/mpic.txt       |    9 ++++++++-
> >  arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi            |    1 +
> >  2 files changed, 9 insertions(+), 1 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt b/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
> > index 2cf38bd..ebafba2 100644
> > --- a/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
> > +++ b/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
> > @@ -56,7 +56,14 @@ PROPERTIES
> >            to the client.  The presence of this property also mandates
> >            that any initialization related to interrupt sources shall
> >            be limited to sources explicitly referenced in the device tree.
> > -       
> > +
> > +  - big-endian
> > +      Usage: optional
> > +      Value type: <empty>
> > +          If present the MPIC will be assumed to be big-endian.  Some
> > +          device-trees omit this property on MPIC nodes even when the MPIC is
> > +          in fact big-endian, so certain boards override this property.
> > +
> >  INTERRUPT SPECIFIER DEFINITION
> >  
> >    Interrupt specifiers consists of 4 cells encoded as
> > diff --git a/arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi b/arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi
> > index 5c80460..47f2b67 100644
> > --- a/arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi
> > +++ b/arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi
> > @@ -39,6 +39,7 @@ mpic: pic@40000 {
> >  	reg = <0x40000 0x40000>;
> >  	compatible = "fsl,mpic";
> >  	device_type = "open-pic";
> > +	big-endian;
> >  };
> >  
> >  timer@41100 {
> 
> 


