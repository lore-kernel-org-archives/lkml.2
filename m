Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab1DYLao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 07:30:44 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59989 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758386Ab1DYLam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 07:30:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RZI2lGb5GxLmLxrgV+3inuob4uVqCz359SuCN+2BUpd6XLqGjPvRms/6rwfwLz8Mj4
         D4AJ2MCIkmvinhCo2iQiionWi1wFt4ymBpF2Lv7CGs742p4+hgs5nwfY5zvl9g1KSL2L
         v99kvOCQZtmXXZ/v1Blj2z3TMQrxWXTD95bMs=
Date: Mon, 25 Apr 2011 13:30:36 +0200
From: Tejun Heo <htejun@gmail.com>
To: Bruce Stenning <b.stenning@indigovision.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Message-ID: <20110425113036.GL17734@mtj.dyndns.org>
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com>
 <4D9CD275.9000002@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
 <4D9FACC9.7020200@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
 <4DA45CA7.9040102@teksavvy.com>
 <4DA467FB.6020905@teksavvy.com>
 <20110423005610.GC1576@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C7755494A@gretna.indigovision.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C1438B59050E1B4C9482FF3266AD6BA32C7755494A@gretna.indigovision.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 12:07:04PM +0100, Bruce Stenning wrote:
> Tejun, what does it mean to limit a sata link to UDMA/100? I thought that this
> was only for ata devices, and sata devices have the choice of 1.5Gbps, 3Gbps,
> or 6 Gbps. Is that a false assumption? Is it related to early sata devices that
> were still somewhat based on parallel ata designs?

Yeap, devices behind SATA-PATA bridge were still affected by the
transfer mode so libata tries to slow them down too along with link
speed when limiting speed due to errors.  Shouldn't affect native SATA
devices.

-- 
tejun
