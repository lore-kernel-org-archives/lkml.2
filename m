Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1HAOaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 10:30:03 -0400
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:54657 "EHLO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab1HAO36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 10:29:58 -0400
Message-ID: <4E36B860.3020805@ge.com>
Date: Mon, 01 Aug 2011 15:29:52 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] VME Driver Fixes
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Aug 2011 14:26:48.0684 (UTC) FILETIME=[0C5F22C0:01CC5057]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/11 11:20, Manohar Vanga wrote:
> A little background: I work at CERN in the device drivers section and
> we have a lot of VME crates we use in the accelerator controls. We have
> been using an in-house driver for some time now and want to slowly port
> our existing device drivers over to the kernel driver.
> 
> This set of patches adds multiple changes to the VME driver that fix
> various issues, mostly dealing with the device driver model. 

Please can you update the vme_api.txt document as well to fully reflect the
proposed changes.

Martyn

> Some of
> these are based on the changes made by Emilio G. Cota in a previous
> LKML thread at:
> 
>     https://lkml.org/lkml/2010/10/25/480
> 



> Thanks and best regards,
> Manohar Vanga
> 
> Emilio G. Cota (1):
>   staging: vme: allow explicit assignment of bus numbers
> 
> Manohar Vanga (7):
>   staging: vme_user: change kmalloc+memset to kzalloc
>   staging: vme: make [alloc|free]_consistent bridge specific
>   staging: vme: keep track of registered buses
>   staging: vme: add functions for bridge module refcounting
>   staging: vme: rename *_slot_get to *_get_slot
>   staging: vme: add struct vme_dev for VME devices
>   staging: vme: make match() driver specific to improve non-VME64x
>     support
> 
>  drivers/staging/vme/bridges/vme_ca91cx42.c |   54 ++++-
>  drivers/staging/vme/bridges/vme_tsi148.c   |   53 ++++-
>  drivers/staging/vme/devices/vme_user.c     |   63 ++++-
>  drivers/staging/vme/devices/vme_user.h     |    2 +-
>  drivers/staging/vme/vme.c                  |  414 ++++++++++++++++------------
>  drivers/staging/vme/vme.h                  |   56 +++-
>  drivers/staging/vme/vme_api.txt            |    2 +-
>  drivers/staging/vme/vme_bridge.h           |   19 +-
>  8 files changed, 435 insertions(+), 228 deletions(-)
> 


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
