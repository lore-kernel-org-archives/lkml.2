Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023Ab2FURja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 13:39:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759999Ab2FURj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 13:39:29 -0400
Date: Thu, 21 Jun 2012 10:40:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        aarcange@redhat.com, minchan@gmail.com, kosaki.motohiro@gmail.com,
        andi@firstfloor.org, hannes@cmpxchg.org, mel@csn.ul.ie,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH -mm 4/7] mm: make page colouring code generic
Message-Id: <20120621104005.604fa9cc.akpm@linux-foundation.org>
In-Reply-To: <4FE33002.6040703@redhat.com>
References: <1340057126-31143-1-git-send-email-riel@redhat.com>
	<1340057126-31143-5-git-send-email-riel@redhat.com>
	<1340277624.21745.173.camel@twins>
	<4FE33002.6040703@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012 10:30:26 -0400 Rik van Riel <riel@redhat.com> wrote:

> On 06/21/2012 07:20 AM, Peter Zijlstra wrote:
> > On Mon, 2012-06-18 at 18:05 -0400, Rik van Riel wrote:
> >> Fix the x86-64 page colouring code to take pgoff into account.
> >
> > Shouldn't that be a separate patch?
> 
> My idea was that it would be easier to review
> these two nearly identical functions together.
> 
> Andrew, do you have any strong opinions?

It depends on the significance of the change.  I suspect it's one of
things which speeds up many workloads by 1.5% and slows down a few
weird/important ones by 11%.  Which makes it a thing to be put under
the microscope and poked at.  Some people might end up reverting it,
making it tunable/configurable etc etc.

If any of that is true then yes, I guess it should be a standalone thing.
