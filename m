Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0IWPb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:31:27 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:44742 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0IWPb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:31:26 -0400
In-Reply-To: <1285194989.1849.130.camel@haakon2.linux-iscsi.org>
Subject: Re: [PATCH 2/2] siw: Add support for CRC32C offload instruction	using
 libcrypto crc32c-intel
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-rdma-owner@vger.kernel.org, netdev <netdev@vger.kernel.org>
X-Mailer: Lotus Notes Release 7.0.1 January 17, 2006
Message-ID: <OF8F21A2C4.F0CC977E-ONC12577A7.0054E314-C12577A7.00554592@ch.ibm.com>
From: Bernard Metzler <BMT@zurich.ibm.com>
Date: Thu, 23 Sep 2010 17:31:23 +0200
X-MIMETrack: Serialize by Router on D12MC302/12/M/IBM(Release 8.5|December 05, 2008) at
 23/09/2010 17:31:23
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



linux-rdma-owner@vger.kernel.org wrote on 09/23/2010 12:36:29 AM:

> On Wed, 2010-09-22 at 16:06 -0600, Jason Gunthorpe wrote:
> > On Wed, Sep 22, 2010 at 02:38:31PM -0700, Nicholas A. Bellinger wrote:
> >
> > > So I think the main bit here is the ability to request
> > > crc32c-intel.ko first, and then fall back to crc32c.ko when the
> > > former is not available on CONFIG_X86.
> >
> > Well, it is what Andi said, everything is working fine but there is no
> > mechanism to autoload the accelerated crypto module. If you did
> > modprobe crc32c_intel prior to loading your driver it would
> > automatically get crc32c-intel when it asks for crc32c since it is
> > loaded and a higher priority.
> >
>
> Ah, OK.  I see what you mean now here wrt to libcrypto priorities and
> crc32c + crc32c_intel modules.   My apologies for the in-experience with
> libcrypto here..
>
> > So, the drivers are correct to just request crc32c .. The work around
> > to limited autoprobing is so trivial (modprob crc32_intel) I'm not
> > sure including extra autoprobing code in the drivers is worthwhile?
> >
>
> Indeed, I am happy to drop this patch if Bernard would be nice enough to
> add a 'modprobe crc32_intel' into the SIW scripts.
>

Ok, thanks for the CRC comments, quite instructive.  To sum up, now I'll
add
a minimum siw bringup script to the kernel part.

Bernard

