Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab1LEPhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 10:37:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56774 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932387Ab1LEPhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 10:37:12 -0500
Date: Mon, 5 Dec 2011 15:37:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>
Subject: Re: [PATCH 2/2 v4] pinctrl: introduce generic pin config
Message-ID: <20111205153709.GU11150@opensource.wolfsonmicro.com>
References: <1322160380-27711-1-git-send-email-linus.walleij@stericsson.com>
 <74CDBE0F657A3D45AFBB94109FB122FF174FDAFF30@HQMAIL01.nvidia.com>
 <CACRpkdZueyZkOq20qq_jDn27cfkChM58cR+TvPKfifSwFwiQ5w@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF174FDB01F2@HQMAIL01.nvidia.com>
 <CACRpkdYJkLHtn9_Evw4m3rUCtzRoR9quinpHA3YEF2kt=cEd5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYJkLHtn9_Evw4m3rUCtzRoR9quinpHA3YEF2kt=cEd5g@mail.gmail.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 02:35:07PM +0100, Linus Walleij wrote:
> On Thu, Dec 1, 2011 at 6:16 PM, Stephen Warren <swarren@nvidia.com> wrote:

> > I think that'd be fine; the generic code would do all the debug prints
> > for the standardized enums, then the core would call into the pinctrl
> > driver to perform any additional debug prints for any driver-defined
> > custom parameters.

> I think Marks point earlier was that he wanted the possibility
> to cut out *all* the generic stuff and have only custom config
> enumerators for a certain pin controller.

Pretty much.  Or at least have a way of doing that.  But I do think this
should have a way of coexisting with the standard properties where
that's possible.

My main concern here is that going through too much of an abstraction
layer looks like it could be an awful lot more work and I'm not entirely
clear what it'd buy us - things like readback debug decode into user
readable values are an example of a useful thing, though.
