Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab1C2AZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 20:25:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:39473 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab1C2AZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 20:25:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YhKWGbTTgDZcopJgyQmFb3wQoTRVBB8ukD5trgpCE9sI4BZD0CxAV6JgKpevSzZgIT
         9M5jdf+94HkHU6zOXV2g==
MIME-Version: 1.0
In-Reply-To: <081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
	<BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
Date: Mon, 28 Mar 2011 17:25:24 -0700
Message-ID: <BANLkTikzpC9DdaoWaUTvO98jnjFdJOomwQ@mail.gmail.com>
Subject: Re: XFS memory allocation deadlock in 2.6.38
From: Michel Lespinasse <walken@google.com>
To: Sean Noonan <Sean.Noonan@twosigma.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Bligh <Martin.Bligh@twosigma.com>,
        Trammell Hudson <Trammell.Hudson@twosigma.com>,
        Christos Zoulas <Christos.Zoulas@twosigma.com>,
        "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>,
        Stephen Degler <Stephen.Degler@twosigma.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 2:34 PM, Sean Noonan <Sean.Noonan@twosigma.com> wrote:
>> Could you test if you see the deadlock before
>> 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272 without MAP_POPULATE ?
>
> Built and tested 72ddc8f72270758951ccefb7d190f364d20215ab.
> Confirmed that the original bug does not present in this version.
> Confirmed that removing MAP_POPULATE does cause the deadlock to occur.

It seems that the test (without MAP_POPULATE) reveals that the root
cause is an xfs bug, which had been hidden up to now by MAP_POPULATE
preallocating disk blocks (but could always be triggered by the same
test without the MAP_POPULATE flag). I'm not sure how to go about
debugging the xfs deadlock; it would probably be best if an xfs person
could have a look ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
