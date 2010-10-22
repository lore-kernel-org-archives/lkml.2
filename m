Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0JVKKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 06:10:22 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:52331 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0JVKKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 06:10:21 -0400
Message-ID: <4CC162BA.6080009@ge.com>
Date: Fri, 22 Oct 2010 11:08:58 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: Re: [-next] staging/vme: various fixes + new driver model for VME
References: <1287729412-24356-1-git-send-email-cota@braap.org>
In-Reply-To: <1287729412-24356-1-git-send-email-cota@braap.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2010 10:10:18.0606 (UTC) FILETIME=[544458E0:01CB71D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 22/10/10 07:36, Emilio G. Cota wrote:
> Hi Greg,
> 
> This contains first a whole bunch of fixes to the existing vme
> code in staging, to then introduce a new driver model for VME
> in patch 27.
> 

Emilio,

The VME drivers are currently in the staging tree - please can you post
these patches to the mailing list identified in the maintainers file
(devel@driverdev.osuosl.org) so that these modifications can be
discussed there.

MArtyn


> I have a short list of things to do after this patchset gets
> reviewed:
> 
> - provide a saner API for VME drivers that just want to
>   map/unmap chunks of memory (knowing nothing about underlying
>   hardware features, such as windows). This is already
>   implemented in the out-of-tree driver in [1].
> 
> - Make DMA work on the tsi148 (it's the only bridge I've got).
>   This will probably involve changing or extending the
>   current API.
> 
> - Test the whole thing with real hardware and a real VME driver
>   (currently out of tree as well, see [2]), which I'll try
>   to get merged, too--currently we just have vme_user.c which
>   really isn't a kosher driver.
> 
> 
> 
> Note that the appended applies on top of linux-next.
> 
> The patchset can be pulled from:
> git://github.com/cota/linux-2.6.git vme-next
> 
> Thanks,
> 
>                 Emilio
> 
> 
> [1] http://repo.or.cz/w/ht-drivers.git/tree/HEAD:/vmebridge/driver
> [2] http://repo.or.cz/w/ht-drivers.git/tree/HEAD:/sis33/drivers
> 
> diffstat:
> 
>  drivers/staging/vme/bridges/vme_ca91cx42.c |  222 ++++++------
>  drivers/staging/vme/bridges/vme_ca91cx42.h |    2 +-
>  drivers/staging/vme/bridges/vme_tsi148.c   |  259 +++++++-------
>  drivers/staging/vme/bridges/vme_tsi148.h   |    2 +-
>  drivers/staging/vme/devices/vme_user.c     |  159 ++++-----
>  drivers/staging/vme/vme.c                  |  569 +++++++++++++++-------------
>  drivers/staging/vme/vme.h                  |  229 ++++++++++-
>  drivers/staging/vme/vme_bridge.h           |  175 ---------
>  8 files changed, 831 insertions(+), 786 deletions(-)
> 
> 


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
