Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030288Ab2LHTpN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 14:45:13 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41836 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030221Ab2LHTpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 14:45:11 -0500
X-Sasl-enc: mi6eAmMVjr4o7P1LL+TaJXpHD+3S1hUn2F/1nUWIJ1+V 1354995909
Date: Sat, 8 Dec 2012 11:47:26 -0800
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: zram: fix invalid memory references during disk write
Message-ID: <20121208194726.GD3897@kroah.com>
References: <1354257909-2380-1-git-send-email-ngupta@vflare.org>
 <CAPkvG_er9VYk6Qi5o_Gz33qYN1Mr9jPUXMBm461Q8dtQC4iEdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPkvG_er9VYk6Qi5o_Gz33qYN1Mr9jPUXMBm461Q8dtQC4iEdw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 04:50:37PM -0800, Nitin Gupta wrote:
> On Thu, Nov 29, 2012 at 10:45 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> > Fixes a bug introduced by commit c8f2f0db1 ("zram: Fix handling
> > of incompressible pages") which caused invalid memory references
> > during disk write. Invalid references could occur in two cases:
> >  - Incoming data expands on compression: In this case, reference was
> > made to kunmap()'ed bio page.
> >  - Partial (non PAGE_SIZE) write with incompressible data: In this
> > case, reference was made to a kfree()'ed buffer.
> >
> > Fixes bug 50081:
> > https://bugzilla.kernel.org/show_bug.cgi?id=50081
> >
> > Upstream commit ID: c8f2f0d: zram: Fix handling of incompressible pages
> > Apply to versions: 3.6.5, 3.6.6, 3.6.7, 3.6.8
> >
> 
> Greg: can you please apply these patches to above stable versions
> and also 3.6.9?

Hm, sorry, I thought this was for the 3.7 tree, I'll queue this up for
the next round of 3.6-stable patches.

thanks,

greg k-h
