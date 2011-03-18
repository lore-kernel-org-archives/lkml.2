Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1CRITW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:19:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63112 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab1CRITS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:19:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: RFC: Platform data for onboard USB assets
Date: Fri, 18 Mar 2011 09:19:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: andy.green@linaro.org, Greg KH <greg@kroah.com>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <20110311165642.GA9996@kroah.com> <4D8296D1.9060106@linaro.org> <20110318045401.GA18545@angua.secretlab.ca>
In-Reply-To: <20110318045401.GA18545@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103180919.05521.arnd@arndb.de>
X-Provags-ID: V02:K0:pbJkckpB/y2PyanrYZt4x3ry0Iw7ILLDbWOAgyrii7P
 E/2TnNjg7eyYsabDRnuv8cVOqtr01ryGcfLt4xgN8BKKTLdSRU
 lOrpsT7ZONroSrB45cN1qde+6U2OiJGJQhwsdYiLaSFWTd/3bE
 CRnS5I2zdkqGkDxFyuaf6JcUDP/Or2fSDCcdp7jcRUBroj+gJ8
 EsQ6uwEpMbAHp1+QbMKYw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 March 2011, Grant Likely wrote:
> On Thu, Mar 17, 2011 at 11:18:41PM +0000, Andy Green wrote:
> > On 03/17/2011 10:53 PM, Somebody in the thread at some point said:
> > 
> > >>Not tested!
> > >>
> > >>Signed-off-by: Arnd Bergmann<arnd.bergmann@linaro.org>
> > >
> > ><snip>
> > >
> > >Very nice.
> > >
> > >Andy and Mark, would this patch work for you?
> > 
> > You do realize this untested patch depends on 13 year old vapour
> > definition of general usb device tagging in Device Tree that does
> > not exist yet?
> 
> IIRC, not vapour.  I believe this binding is currently used by Open
> Firmware on existing PowerPC, SPARC and x86 machines.  Linux doesn't
> use the binding because up to this point Linux hasn't cared about how
> firmware initialized the usb bus.  It just reinitializes everything
> anyway.

I'm not proposing to use the binding for the complete USB probing, that
would just duplicate the probing code that we already have. We could
howeve check some properties from the binding against what the Linux
drivers see.

Most importantly, we can assign the device_node pointer for each
hardwired USB device to the usb_device structure, that should be
really simple. The only reason why I pointed to the spec is to
make sure we don't put incompatible properties in the tree and
instead just do whatever we need according to the spec but leave
out all the optional parts.

	Arnd
