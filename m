Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1LAGWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 01:22:23 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:9322 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab1LAGWW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 01:22:22 -0500
X-SpamScore: -18
X-BigFish: VS-18(zz9371K179dN1432N98dKzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 1 Dec 2011 14:34:48 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 6/8] of: add clock providers
Message-ID: <20111201063447.GH711@S2100-06.ap.freescale.net>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
 <1320801583-12774-7-git-send-email-grant.likely@secretlab.ca>
 <20111121153716.GA16417@S2100-06.ap.freescale.net>
 <CACxGe6teGPmgOiwSVQ_PebXo=9x8EVwjH2qQYi5LU813BvY3Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CACxGe6teGPmgOiwSVQ_PebXo=9x8EVwjH2qQYi5LU813BvY3Ow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 12:38:19PM -0700, Grant Likely wrote:
> On Mon, Nov 21, 2011 at 8:37 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> > On Tue, Nov 08, 2011 at 06:19:41PM -0700, Grant Likely wrote:
> >> +struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
> >> +{
> >> +     int index = 0;
> >> +
> >> +     if (name)
> >> +             index = of_property_match_string(np, "clock-input-names", name);
> >
> > If it fails to match name, we may want to force 'index' back to 0.
> 
> Actually, if it fails to match, the function should fail.

Hmm, that will require the clock-input-name be same as the second
parameter of clk_get() - con_id, which may have been named to some
string not suitable for clock-input-name.  For those case, we will
probably need to change the drivers to rename the con_id?  Or just
force the clock-input-name to be that improper con_id string?

-- 
Regards,
Shawn

