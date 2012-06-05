Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761777Ab2FEK2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:28:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:43184 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761760Ab2FEK2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:28:00 -0400
Message-ID: <1338892071.28282.157.camel@twins>
Subject: Re: [PATCH] perf: Fix intel shared extra msr allocation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org
Date: Tue, 05 Jun 2012 12:27:51 +0200
In-Reply-To: <CABPqkBSv8CbMzUiRsN2uOF1v6rFTpzhQqNbo7OKe-nzsus0GDg@mail.gmail.com>
References: <1338520856-21020-1-git-send-email-zheng.z.yan@intel.com>
	 <CABPqkBScjC5fJbTc1rYtbtRqOCyJ+7QUbdE32DgMcffBAGJNVw@mail.gmail.com>
	 <CAAM7YAkYgUjwQptYvyeVawzcD5x4c-bTT_=+6AMyUb+-6HoMuQ@mail.gmail.com>
	 <1338891271.28282.155.camel@twins>
	 <CABPqkBSv8CbMzUiRsN2uOF1v6rFTpzhQqNbo7OKe-nzsus0GDg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 12:21 +0200, Stephane Eranian wrote:
> I agree with the first part of the patch in intel_try_alt_er(), we
> should not touch
> the actual event struct. But I am still unclear about the reg->alloc part.

reg->alloc is part of the actual event.

Thing is, the patch is horridly ugly.. while I agree that changing event
state isn't good, special casing all that code isn't good either.

I was looking at cloning the events for validate_group() as well, but so
far that's not turning out too pretty either.
