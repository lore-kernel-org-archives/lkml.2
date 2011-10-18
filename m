Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab1JRKu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 06:50:57 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:20359 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab1JRKu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 06:50:56 -0400
X-IronPort-AV: E=Sophos;i="4.69,364,1315180800"; 
   d="scan'208";a="8442109"
Subject: Re: [PATCH] Fix guest memory leak and panic
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Krishna Kumar2 <krkumar2@in.ibm.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Tue, 18 Oct 2011 11:50:55 +0100
In-Reply-To: <OFB632D60B.6534A38B-ON6525792D.003A1B21-6525792D.003B0DB8@in.ibm.com>
References: <20111018080523.16861.55402.sendpatchset@krkumar2.in.ibm.com>
	 <1318927016.16132.49.camel@zakaz.uk.xensource.com>
	 <1318931232.16132.65.camel@zakaz.uk.xensource.com>
	 <OFB632D60B.6534A38B-ON6525792D.003A1B21-6525792D.003B0DB8@in.ibm.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318935055.3385.0.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 11:46 +0100, Krishna Kumar2 wrote:
> Ian Campbell <Ian.Campbell@citrix.com> wrote on 10/18/2011 03:17:11 PM:
> 
> > > I think the best thing might be to remove the additional ref taking
> from
> > > the setter function and audit the previous changes to ensure they
> > > conform. I'll do that right away and post a fixup patch ASAP.
> >
> > Sigh, only one out of the ten callers of (__)skb_frag_set_page expects
> > skb_frag_set_page to take a new reference. I think that's pretty
> > comprehensive evidence that the current behaviour is unexpected and
> > wrong.
> 
> Looks good!

Thanks.

> Does it make sense to commit both of these patches? The
> reason being - my patch becomes a cleanup of set_skb_frag()
> in virtio_net driver.

I think your patch remains a valid cleanup but I don't maintain that
code.

Ian.


