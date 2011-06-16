Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab1FPSl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:41:58 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:58643 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751638Ab1FPSly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:41:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WmS3Db/7D+tgtQ2yM8n/4Wyr+sBgw+hJ1Ty82HouK7Cqa9UrobZngYrqnVRr7IBYKRGuAkkGi0hh2HgcHO0ZsgzTUSoJmr1yavYV6IqOq+ktsNamB0qk0QHyOrwHBfB4;
Date: Thu, 16 Jun 2011 11:41:46 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [2.6.39] drm/i915: blank screen on Lenovo Ideapad U160
Message-ID: <20110616114146.4662ea2f@jbarnes-desktop>
In-Reply-To: <gisjr9ll0j.fsf@mx10.gouders.net>
References: <gi1uzevjl4.fsf@mx10.gouders.net>
	<alpine.DEB.2.00.1105311406210.5012@localhost6.localdomain6>
	<gitycau362.fsf@mx10.gouders.net>
	<giei3eoeic.fsf@mx10.gouders.net>
	<gi1uyx8m2f.fsf_-_@mx10.gouders.net>
	<20110615115903.685acba0@jbarnes-desktop>
	<giips6lr5a.fsf@mx10.gouders.net>
	<20110615144132.074167f3@jbarnes-desktop>
	<giei2ulpl1.fsf@mx10.gouders.net>
	<20110615150737.79cd5de7@jbarnes-desktop>
	<gi4o3q2plu.fsf@karga.hank.lab>
	<gizkli0zew.fsf@karga.hank.lab>
	<20110616094030.15714852@jbarnes-desktop>
	<gisjr9ll0j.fsf@mx10.gouders.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011 19:54:36 +0200
Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:

> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
> 
> > On Thu, 16 Jun 2011 13:49:11 +0200
> > Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
> >
> >> Some redundant information, but if I change one line at another place
> >> in the i915 code (whithout the above modification) the result is more
> >> satisfactory on my machine, because in that case the display even works
> >> after I close and reopen the lid:
> >> 
> >> diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
> >> index 927442a..ebb67ae 100644
> >> --- a/drivers/gpu/drm/i915/intel_bios.c
> >> +++ b/drivers/gpu/drm/i915/intel_bios.c
> >> @@ -267,7 +267,7 @@ static int intel_bios_ssc_frequency(struct drm_device *dev,
> >>         case 4:
> >>                 return alternate ? 100 : 96;
> >>         default:
> >> -               return alternate ? 100 : 120;
> >> +               return alternate ? 120 : 100;
> >>         }
> >>  }
> >
> > Does your machine also work if you set the lvds_use_ssc param to 0?
> 
> Yes, that works!
> I undid all modifications, compiled the i915 driver as a module (I am
> not sure if that is necessary) und used i915.lvds_use_ssc=0 as a
> further bootparameter, I will attach the dmesg output.
> 
> Would you say "This problem was just a case of wrong parameter usage",
> then?

No, we should be parsing the VBT differently in your case it appears.
But the simple change above will break other platforms, so it's
possible we're missing a VBT format change and need to parse it
differently depending on the version.

-- 
Jesse Barnes, Intel Open Source Technology Center
