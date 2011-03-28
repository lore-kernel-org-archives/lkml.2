Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1C1VGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 17:06:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:56447 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab1C1VGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 17:06:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=g3LOY+fBNG6gKjdXp/pQ+rJtQswJ2rrHRIRi0MzGXKAa3cRN16DZrqJuR/XpviFQOD
         kjMZ+aEToCofmab2Iy6Q==
MIME-Version: 1.0
In-Reply-To: <081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
Date: Mon, 28 Mar 2011 14:06:25 -0700
Message-ID: <BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
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
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 7:58 AM, Sean Noonan <Sean.Noonan@twosigma.com> wrote:
>> Regarding the deadlock: I am curious to see if it could be made to
>> happen before 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272. Could you test
>> what happens if you remove the MAP_POPULATE flag from your mmap call,
>> and instead read all pages from userspace right after the mmap ? I
>> expect you would then be able to trigger the deadlock before
>> 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272.
>
> I still see the deadlock without MAP_POPULATE

Could you test if you see the deadlock before
5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272 without MAP_POPULATE ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
