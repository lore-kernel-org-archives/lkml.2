Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab1IWHcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 03:32:53 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:63682 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1IWHcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 03:32:52 -0400
Date: Fri, 23 Sep 2011 10:30:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] agp: potential info leak in compat_agpioc_info_wrap()
Message-ID: <20110923073004.GE29426@longonot.mountain>
References: <20110923061945.GC4387@elgon.mountain>
 <1316761455.2560.15.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316761455.2560.15.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090206.4E7C3620.02A3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 09:04:15AM +0200, Eric Dumazet wrote:
> > The agp_info32 struct has a 4 byte hole in it so we need to clear
> > that before copying it to userspace.
> > 
> > struct agp_info32 {
> >         struct agp_version         version;              /*     0     0 */
> > 
> >         /* XXX 4 bytes hole, try to pack */
> > 
> 
> This makes no sense :
> 
> Why should we have a 32bit hole before an u32 field ?
> 

Crap.  You're right.  It saw the agp_version struct as a hole.

Sorry for the noise.

regards,
dan carpenter
