Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab1CMUpm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 16:45:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55161 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382Ab1CMUpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 16:45:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: andy.green@linaro.org
Subject: Re: [RFC PATCH 1/4] PLATFORM: introduce structure to bind async platform data to a dev path name
Date: Sun, 13 Mar 2011 21:45:26 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, patches@linaro.org
References: <20110312222633.27020.19543.stgit@otae.warmcat.com> <201103131758.47663.rjw@sisk.pl> <4D7CFD11.5020604@linaro.org>
In-Reply-To: <4D7CFD11.5020604@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103132145.26410.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 13, 2011, Andy Green wrote:
> On 03/13/2011 04:58 PM, Somebody in the thread at some point said:
> 
> > So, you want to have a mechanism telling the driver "if the device
> > happens to have this particular path, use that platform data", right?
> 
> Yeah.
> 
> > And it works because the initialization code kind of knows what path the
> > device is going to be at, so it can predict that and provide the mathing data.
> >
> > Unfortunately, this relies on how device paths are constructed at the moment,
> > so if this approach is adopted in general, it will prevent us from changing
> > that way in the future (or at least it will make that very difficult).
> >
> > Perhaps you could use some other kind of device identification here?
> 
> I'm sorry what prevents you changing paths in the future?
> 
> Nothing does, if you change the bus tag from like usb1 to UsB_1 you just 
> fix up the strings in the board definition files at the same time, they 
> are sitting there in the same tree and
> 
>   grep platform_async_platform_data arch/* -R
> 
> will show them all up in one hit.  It's no different if you changed the 
> name of a driver, you'd patch the board definition files with devices 
> that need to bind to that driver name to uplevel them to the new name.

Well, I'm in the process of doing something similar with sysdevs and, trust me,
it is not fun. :-/

> The board definition file for these SoC cases usually has access to a 
> pointer to the host controller directly since it instantiates them, if 
> this was the only stumbling point and you thought it helped something 
> the matching system can look for that particular pointer being a parent 
> of the candidate probed device.

I think that would have been better than matching based on device paths.

Whether or not it's the only stumbling point depends on what other people
think.

Thanks,
Rafael
