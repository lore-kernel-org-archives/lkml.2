Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab2DELpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 07:45:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58980 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751218Ab2DELo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 07:44:59 -0400
Message-ID: <1333626298.23520.107.camel@joe2Laptop>
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Greg Kroah-Hartmann <greg@kroah.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Apr 2012 04:44:58 -0700
In-Reply-To: <CAPXgP13+UjRsG_LBMd_KbqS=1p_7XA0TaPeXnWQUSdq1tYvW_Q@mail.gmail.com>
References: <1333569554.864.3.camel@mop>
	 <1333583480.23520.37.camel@joe2Laptop> <20120405003321.GB27595@kroah.com>
	 <1333586419.23520.52.camel@joe2Laptop>
	 <CAPXgP11qdyccftPPA9LSRKVb-Xnf8BzP+deUmTzHnuVxoTQKog@mail.gmail.com>
	 <20120405080820.GB17658@merkur.ravnborg.org>
	 <CAPXgP13+UjRsG_LBMd_KbqS=1p_7XA0TaPeXnWQUSdq1tYvW_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-05 at 10:35 +0200, Kay Sievers wrote:
> The use of structured data is mainly focused on subsystem specific
> users. Like the block layer or the network stack could invent a bunch
> of well-defined set of properties, and wrap the emission of these up
> in some common subsystem logging functions for their drivers to use.
> They would reflect common log events, meaningful in the context of a
> specific subsystem.

I think this is generally less useful that you do.

> Think of it more like the model how we handle properties in uevents,
> it's a similar approach.
> 
> This is not so much intended to convert the (almost random) language
> in slightly better (random) key/value pairs.

I think you should highlight this in the changelog.
People _will_ use it that way anyway.

> Userpace, which is the
> only reason to add that stuff in the first place, will need to know
> how to make sense out of the passed values, so in the future, we will
> need some kind of coordination per subsystem here.

I think you should separate your patch a bit.

Don't call it an extension to printk(), it's
hardly that, printk() is a function call that emits
stuff.  The printk subsystem does a lot more.

perhaps:

changes for printk_emit()
changes for dev_printk
changes for devkmsg_


