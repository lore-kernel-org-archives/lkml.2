Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab1IHICM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:02:12 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:17961 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab1IHICK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:5:1>);
	Thu, 8 Sep 2011 04:02:10 -0400
Message-Id: <4E6892B4020000780005536B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 08 Sep 2011 09:02:28 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <hch@infradead.org>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Vivek Goyal" <vgoyal@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: Help with implementing some form of barriers in 3.0
	 kernels.
References: <20110907174832.GN32190@dumpdata.com>
 <20110907181740.GG31726@redhat.com> <20110907201620.GB26548@infradead.org>
In-Reply-To: <20110907201620.GB26548@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.09.11 at 22:16, Christoph Hellwig <hch@infradead.org> wrote:
> [Hmm, for some reason I never manage to receive Konrads mails directly,
>  but only get the replies, or copies via the list]
> 
> On Wed, Sep 07, 2011 at 02:17:40PM -0400, Vivek Goyal wrote:
>> On Wed, Sep 07, 2011 at 01:48:32PM -0400, Konrad Rzeszutek Wilk wrote:
>> > Hey Christoph,
>> > 
>> > I was wondering what you think is the proper way of implementing a
>> > backend to support the 'barrier' type requests? We have this issue were
>> > there are 2.6.36 type guests that still use barriers and we would like
>> > to support them properly. But in 3.0 there are no barriers - hence
>> > the question whether WRITE_fLUSH_FUA would be equal to WRITE_BARRIER?
>> 
>> I think WRITE_FLUSH_FUA is not same as WRITE_BARRIER. Because it does
>> not ensure request ordering. A request rq2 which is issued after rq1 (with
>> WRITE_flush_FUA), can still finish before rq1. In the past WRITE_BARRIER
>> would not allow that.
>> 
>> So AFAIK, WRITE_flush_fua is not WRITE_BARRIER.
> 
> Indeed.  And while most guests won't care some will.  E.g. reiserfs
> which is the standard filesystem in most SuSE guests, which happen to
> be fairly popular with Xen.
> 
> I'd suggest you look at the pre-2.6.36 barrier implementation and see
> if you can move that into xen-blkfront.

That would need to be done in the backend, as the expectation cannot
be to patch old frontends to deal with new backends.

Jan

> For the qemu side doing this is a bit easier as you'll just have to wait
> for all pending aio requests to complete.  The current qemu xen disk
> code gets thus horribly wrong, though.



