Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab2JBVQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:16:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2JBVQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:16:27 -0400
Date: Tue, 2 Oct 2012 14:16:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] aoe: retain static block device numbers for
 backwards compatibility
Message-Id: <20121002141626.4ac3c537.akpm@linux-foundation.org>
In-Reply-To: <1dd6f0e49b1c1fb151ba57df86bff4b81aa0b258.1349104674.git.ecashin@coraid.com>
References: <3c9c2338b9c963e1d5f19cc9ed51b01cf829eeee.1349104674.git.ecashin@coraid.com>
	<1dd6f0e49b1c1fb151ba57df86bff4b81aa0b258.1349104674.git.ecashin@coraid.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2012 19:01:15 -0700
Ed Cashin <ecashin@coraid.com> wrote:

> The old mapping between AoE target shelf and slot addresses and
> the block device minor number is retained as a
> backwards-compatible feature, with a new "aoe_dyndevs" module
> parameter available for enabling dynamic block device minor
> numbers.

OK, so the default behaviour is unchanged and users opt into the new
behaviour by providing this module parameter?

Why is this worth doing?  What behaviour changes would users see if we
defaulted to dynamic minors?


I'm surprised we don't have some library code somewhere for managing a
map of minor numbers - it's an operation which is common to so many
drivers.  It would be bitmap or IDR based, I expect.
