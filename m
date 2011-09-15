Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1IOGq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 02:46:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab1IOGq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 02:46:56 -0400
Date: Thu, 15 Sep 2011 08:35:43 +0200
From: Greg KH <gregkh@suse.de>
To: Anton Blanchard <anton@samba.org>
Cc: nfont@austin.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory hotplug: Refuse to add unaligned memory regions
Message-ID: <20110915063543.GA29211@suse.de>
References: <20110915062615.782bc4df@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110915062615.782bc4df@kryten>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 06:26:15AM +1000, Anton Blanchard wrote:
> 
> The sysfs memory probe interface allows unaligned regions
> to be added:
> 
> # echo 0xffffff > /sys/devices/system/memory/probe
> 
> # cat /proc/iomem 
> 00ffffff-01fffffe : System RAM
> 01ffffff-02fffffe : System RAM
> 02ffffff-03fffffe : System RAM
> 03ffffff-04fffffe : System RAM
> 04ffffff-05fffffe : System RAM
> 
> Return -EINVAL instead of creating these bad regions.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---

Is this something that should go into 3.1 and older kernels to properly
handle this type of error?

greg k-h
