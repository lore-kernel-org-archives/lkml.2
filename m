Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab1HRGAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 02:00:46 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:53602 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1HRGAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 02:00:44 -0400
Date: Wed, 17 Aug 2011 23:00:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: JJ Ding <jj_ding@emc.com.tw>
Cc: gaowanlong@cn.fujitsu.com, Daniel Kurtz <djkurtz@chromium.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 5/6] Input: elantech - clean up elantech_init
Message-ID: <20110818060038.GA10093@core.coreip.homeip.net>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw>
 <1313632629-23603-6-git-send-email-jj_ding@emc.com.tw>
 <CAGS+omDVn1uoU85pPN+jeHMTMp83EA13b3E8Sca0QOqDBZHQFg@mail.gmail.com>
 <4E4C8218.8040100@cn.fujitsu.com>
 <87aab746ys.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aab746ys.fsf@emc.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 01:35:55PM +0800, JJ Ding wrote:
> Hi Wanlong Gao, Daniel,
> 
> On Thu, 18 Aug 2011 11:08:08 +0800, Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:
> > On 08/18/2011 11:04 AM, Daniel Kurtz wrote:
> > > On Thu, Aug 18, 2011 at 9:57 AM, JJ Ding<jj_ding@emc.com.tw>  wrote:
> > >>   /*
> > >> + * determine hardware version and set some properties according to it.
> > >> + */
> > >> +static void elantech_set_properties(struct elantech_data *etd)
> > >> +{
> > >> +       /*
> > >> +        * Assume every version greater than 0x020030 is new EeePC style
> > >> +        * hardware with 6 byte packets, except 0x020600
> > >> +        */
> > >> +       if (etd->fw_version<  0x020030 || etd->fw_version == 0x020600)
> > >> +               etd->hw_version = 1;
> > >> +       else
> > >> +               etd->hw_version = 2;
> > >> +
> > >> +       /*
> > >> +        * Turn on packet checking by default.
> > >> +        */
> > >> +       etd->paritycheck = 1;
> > >
> > > Assuming paritycheck goes away:
> > Agree.
> I thought about removing it, too. But it occured to me that v1 and v2
> hardware can still have the sysfs entry to turn off parity check.
> 
> And since it's exposed in sysfs, I suppose there might be some init
> scripts relying on it.
> 
> What do you think, Dmitry?
> Shall I remove it?

No, we should not remove it, since it is useful for V1 hardware which we
still support.

How confident are we in the V2/V3 checking not tripping on valid packets?

Thanks.

-- 
Dmitry
