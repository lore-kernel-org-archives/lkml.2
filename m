Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972Ab1CDSZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:25:32 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:47040 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759729Ab1CDSZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:25:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WmfMeinA8EuWjzh4E0uBIPhZq8dqYOYt4azCRxQCHVoagE69i5a0InnQW3L3tJRMFW2h8yFJzDDUev/Gz21z9wPPt/0TmrbrJBySMaDVk/nSyKRUH+pOugKGqCjv9+66;
Date: Fri, 4 Mar 2011 10:25:22 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Don Dutile <ddutile@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] pci: use security_capable() when checking
 capablities during config space read
Message-ID: <20110304102522.5c126fcf@jbarnes-desktop>
In-Reply-To: <20110210235856.GD9869@sequoia.sous-sol.org>
References: <1297318312-14309-1-git-send-email-chrisw@sous-sol.org>
	<1297318312-14309-3-git-send-email-chrisw@sous-sol.org>
	<alpine.LRH.2.00.1102101915000.20298@tundra.namei.org>
	<20110210235856.GD9869@sequoia.sous-sol.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011 15:58:56 -0800
Chris Wright <chrisw@sous-sol.org> wrote:

> * James Morris (jmorris@namei.org) wrote:
> > What about these other users of cap_raised?
> > 
> > drivers/block/drbd/drbd_nl.c:   if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN)) {
> > drivers/md/dm-log-userspace-transfer.c: if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))
> > drivers/staging/pohmelfs/config.c:      if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))
> > drivers/video/uvesafb.c:        if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))
> 
> Those are a security_netlink_recv() variant.  They should be converted
> although makes sense as a different patchset.
> 
> > Also, should this have a reported-by for Eric ?
> 
> Yes it should, thanks.  Below is patch with Reported-by added (seemed
> overkill to respin the series; holler if that's perferred).
> 
> thanks,
> -chris
> ---
> 
> From: Chris Wright <chrisw@sous-sol.org>
> Subject: [PATCH 2/2 v2] pci: use security_capable() when checking capablities during config space read
> 
> Eric Paris noted that commit de139a3 ("pci: check caps from sysfs file
> open to read device dependent config space") caused the capability check
> to bypass security modules and potentially auditing.  Rectify this by
> calling security_capable() when checking the open file's capabilities
> for config space reads.
> 
> Reported-by: Eric Paris <eparis@redhat.com>
> Cc: Eric Paris <eparis@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
>  drivers/pci/pci-sysfs.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

Sorry for the late reply, but this is fine with me.  Should probably
just get pushed along with the change to security_capable (assuming
that hasn't been done already).

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
