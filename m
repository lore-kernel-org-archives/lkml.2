Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0JVJci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 05:32:38 -0400
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:44716 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab0JVJcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 05:32:36 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Oct 2010 05:32:36 EDT
Message-ID: <4CC158B3.5010908@ge.com>
Date: Fri, 22 Oct 2010 10:26:11 +0100
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
X-OriginalArrivalTime: 22 Oct 2010 09:27:30.0630 (UTC) FILETIME=[59A24E60:01CB71CB]
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

Hi Emilio,

Thank you for the fixes. After a quick glance, there seem to be a number
of valid fixes here, but I'm very concerned by the patches that change
the driver model. We discussed this approach in August last year, I am
still yet to be convinced by the approach you wish to take.

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

The DMA is already working on the tsi148. In what way do you feel that
the current API needs changing or extending for DMA?

> - Test the whole thing with real hardware and a real VME driver
>   (currently out of tree as well, see [2]), which I'll try
>   to get merged, too--currently we just have vme_user.c which
>   really isn't a kosher driver.
> 

The current API has been tested with real hardware, for both supported
vme bridges, on multiple cards, by multiple people. If the changes to
the API are to be applied, they would need to be throughly tested before
they are applied. As I've said above - I am still not convinced by the
change in approach.

Martyn

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
