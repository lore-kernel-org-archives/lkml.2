Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1FNGwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 02:52:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53609 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1FNGwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 02:52:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RdwDWjjVop7IFnfnPFTE1jhxYVRB4kuFSQzjBg2AAKiZyAecp+MwQ3taH24VCZoWI+
         GnLcEIMLrv0QPRh7bC4nc+IdHrOzaW4HSqqmDS0MxUyjcVpzR+HdDQV6bIPOH/Z6XV2i
         00DVoNFOTe450b8xCrCG1aAvZIldmWCyKkSjU=
Date: Tue, 14 Jun 2011 08:52:13 +0200
From: Tejun Heo <tj@kernel.org>
To: Yuan-Hsin Chen <yuanlmm@gmail.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: Re: [PATCH] ahci: enable pmp but connected to HDD issue fixed
Message-ID: <20110614065213.GD8141@htj.dyndns.org>
References: <1308030504-3026-1-git-send-email-yuanlmm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308030504-3026-1-git-send-email-yuanlmm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 01:48:24PM +0800, Yuan-Hsin Chen wrote:
> From: Yuan-Hsin Chen <yhchen@faraday-tech.com>
> 
> When enabling both port multiplier and platform ahci sata, ahci
> times out while connecting to HDD directly. This is because soft
> reset fails with IPMS set. Do soft reset again to port 0.
> 
> The soft reset sequence is copied from ahci.c.

This is the same one as ahci_sb600_softreset(), right?  Please don't
copy & paste like that.  Rename and ahci_sb600_softreset() to
libahci.c, create a separate ata_port_operations for it and use the
ops for the affected controllers.

Thanks.

-- 
tejun
