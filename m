Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab1JRK2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 06:28:38 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:45074 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1JRK2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 06:28:37 -0400
In-Reply-To: <1318927016.16132.49.camel@zakaz.uk.xensource.com>
References: <20111018080523.16861.55402.sendpatchset@krkumar2.in.ibm.com> <1318927016.16132.49.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH] Fix guest memory leak and panic
X-KeepSent: F9A5DA76:A2860DAC-6525792D:0039157B;
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
Message-ID: <OFF9A5DA76.A2860DAC-ON6525792D.0039157B-6525792D.00396BDE@in.ibm.com>
From: Krishna Kumar2 <krkumar2@in.ibm.com>
Date: Tue, 18 Oct 2011 15:58:52 +0530
X-MIMETrack: Serialize by Router on d23ml172/23/M/IBM(Release 8.5.1FP5|September 29, 2010) at
 18/10/2011 15:58:54
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
x-cbid: 11101810-2000-0000-0000-000000721C3A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell <Ian.Campbell@citrix.com> wrote on 10/18/2011 02:06:56 PM:

Hi Ian,

> On Tue, 2011-10-18 at 09:05 +0100, Krishna Kumar wrote:
> > The extra reference to the fragment pages causes those pages to
> > not get freed in skb_release_data(). The following patch fixes
> > the bug. I have not checked if any other converted driver has
> > the same issue.
>
> Damn. You are completely correct and I appear to have made this same
> mistake several times. A quick look suggests that at least cxbg,
> myriage, vmxnet, cassini and bnx2 may potentially have a similar
> issue :-( (I stopped looking at that point, I'll obviously do a full
> audit).
>
> I considered quite carefully whether (__)skb_frag_set_page should take a
> reference or not and decided yes but I'm starting to reconsider whether
> I made the right choice. It seems that is just confusing and violates
> the principal of least surprise to have a function called "set" take a
> new reference. In reality all existing drivers expect that adding a page
> to an SKB frag will just take over the existing reference.
>
> I think the best thing might be to remove the additional ref taking from
> the setter function and audit the previous changes to ensure they
> conform. I'll do that right away and post a fixup patch ASAP.
>
> > Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
>
> This change is correct as things stand today, so:
>
> Acked-by: Ian Campbell <ian.campbell@citrix.com>
>
> but perhaps it would be better to hold off and let me fix all of these
> all at once.

Either way is fine with me. However, besides having a fix,
I would like to remove the manual initializations in
set_skb_frag(), and substitute with __skb_fill_page_desc,
like other drivers do.

thanks,

- KK

