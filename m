Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab1JRNUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:20:47 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34820 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab1JRNUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:20:45 -0400
In-Reply-To: <1318935055.3385.0.camel@zakaz.uk.xensource.com>
References: <20111018080523.16861.55402.sendpatchset@krkumar2.in.ibm.com>	 <1318927016.16132.49.camel@zakaz.uk.xensource.com>
	 <1318931232.16132.65.camel@zakaz.uk.xensource.com>	 <OFB632D60B.6534A38B-ON6525792D.003A1B21-6525792D.003B0DB8@in.ibm.com> <1318935055.3385.0.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH] Fix guest memory leak and panic
X-KeepSent: F565DE9F:92BF6FE5-6525792D:00488336;
 type=4; name=$KeepSent
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OFF565DE9F.92BF6FE5-ON6525792D.00488336-6525792D.00494D56@in.ibm.com>
From: Krishna Kumar2 <krkumar2@in.ibm.com>
Date: Tue, 18 Oct 2011 18:52:19 +0530
X-MIMETrack: Serialize by Router on d23ml172/23/M/IBM(Release 8.5.1FP5|September 29, 2010) at
 18/10/2011 18:52:22
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell <Ian.Campbell@citrix.com> wrote on 10/18/2011 04:20:55 PM:

> > > Sigh, only one out of the ten callers of (__)skb_frag_set_page
expects
> > > skb_frag_set_page to take a new reference. I think that's pretty
> > > comprehensive evidence that the current behaviour is unexpected and
> > > wrong.
> >
> > Looks good!
>
> Thanks.

Tested this patch for virtio_net - hang/panic is fixed.
MemFree also doesn't reduce at end of test compared to
the start.

Tested-by: krkumar2@in.ibm.com

- KK

> > Does it make sense to commit both of these patches? The
> > reason being - my patch becomes a cleanup of set_skb_frag()
> > in virtio_net driver.
>
> I think your patch remains a valid cleanup but I don't maintain that
> code.
>
> Ian.
>
>

