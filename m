Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab0LNH6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 02:58:42 -0500
Received: from web31810.mail.mud.yahoo.com ([68.142.207.73]:43374 "HELO
	web31810.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754009Ab0LNH6k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 02:58:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=bDoaTlJg43BHFeWwRYmapuO5g8B29hamdQ5h1jcTdkmZYq8PhLeDg6sA3Ge1SxjkH9xnIJfShJvmPpYDOEeVRh41NCBPZeMUkLnjImzruyMsQuWzScN0R/jphqkrkYbj+lYFzaL18PXd/4own3vsDtxYqBV/mTZ0x7MwQ9D3USU=;
Message-ID: <807184.43101.qm@web31810.mail.mud.yahoo.com>
X-YMail-OSG: ShQpbIEVM1mG3RmoPry4njUkXwQtVFLma8WYKHegrHNogJV
 SAZHlYLxdaHZSmIYKImMO8X6xT0fWySMsQz9M0rNBYwkI83mPG9msGMm4mzL
 saP6dAT74mKnE0.mHVM_dz1aNX501dmwoqMsre.IUCiEobEjg.GYk_eH4esj
 qncyhOurO93r9M_QOMhesdTnTn1_5g4RK9BsKMXtN_7Q4e7.Hr2diHjbWaoH
 uJj6WMAito6NM6Q_IulD2TXHHDp5ExT5uHUezaKNxo7yU4AdQCcupjk7uSET
 i7J9JsNflsC.b9C.YLYwXMcn2SMNZThhnx2U6ygk4sJYsKiSue4b_9Yhkq7S
 3pjWfbEY3zfyt7t1Ml5DfZ6GCXtrtZDZ477cvyDqfiZ8p6M9_TY3tRnf8eqD
 Xx6ib.CijFPW6
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Mon, 13 Dec 2010 23:58:38 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UAS: Achitecture; TMF; more
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <20101120015519.GA20191@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 11/19/10, Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
> 
> Why do you limit the number of streams this way?  USB
> 3.0 devices can
> support up to 65533 streams, so why place an arbitrary
> limit like this?
> Just use the MaxStreams field in the SuperSpeed Endpoint
> Companion
> descriptor in the call to usb_alloc_streams().  I
> don't see how limiting
> the number of streams you allocate to 128 when the original
> driver tried
> to allocate 256 is an improvement.

Is any of this relevant now? Just take a look at uasp.c--it's how it's done.

> Couldn't the renaming code could have made it into a
> separate
> patch?

That was the least of the changed I would've done. Refer to uasp.c--it's how it's done.

> It also makes it hard to wade through the
> changes.  You should
> have two patches at least: one to rename uas_dev_info, and
> one to rename
> qdepth.  There's places in the code where you've
> changed how you use
> qdepth, and it's hard to see because the rename and change
> are in one
> patch.

I think I've responded to this before to Alan and Greg, it basically goes some like "... one changed warranted another and so on and so forth and I ended up with this big thing..." Better off rip the whole thing off and do it right.

> Matthew and you can dicker over the name for uas_dev_info,

"dicker"? Sorry, I've not time for this. Refer to uasp.c--it's how it's done.

> but I really
> don't understand your reasoning for renaming it to
> uas_tport_info.  What
> type of "ports" are you talking about?  USB ports or
> some other type of
> ports?  To me, uas_dev_info made sense because it
> stored information
> about the particular UAS device, not the USB port it was
> attached to...

Refer to uasp.c, and the 18 points which I listed talking about the I_T_L_Q nexus...

> Tag ID or stream ID is the same, I suppose.  But
> stream IDs are always
> positive integers, so why should tag be signed?

I don't like to educate on mailing lists, especially here. (It always leads to this pointless argument, so I either ignore the question or patronize the questioner in order to get on with it.) Let alone trying to pass a patch that changes this... Just use uasp.c.

> I'm a bit confused by this comment, perhaps because you
> didn't explain
> what TMFs are in your comment or your commit message.
> 
> However, if you're telling the xHCI driver to allocate
> UAS_MAX_STREAMS,
> the UAS driver gets to put stream ID 1 to stream ID
> UAS_MAX_STREAMS in
> urb->stream_id.  If you submit an URB with
> urb->stream_id greater than
> UAS_MAX_STREAMS, the xHCI driver is going to reject that
> submission.
> 
> It looks like from the comment you expect to be able to use
> a stream ID
> as big as UAS_MAX_STREAMS+2+TMF_MAX_TAGS, is that what you
> were trying
> to do?

Check with uasp.c on how it's done.

   Luben

