Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab0IBK63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 06:58:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45804 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab0IBK62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 06:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qrqrJWvSeyaGoFs0lq7nQYFqRO9AGdHRgz5BLE+dFiGbMtH37HT4CQGVs9JPKs5who
         PPemePMgHAPHpuld0arTU3PzWap71ywgh1tEFh46d+L2Yz1MAZcWqm/mg0xuLUvbW7Pk
         1L98QKhvJX1mcdRVxFSBxPPT2elq5I8gNFFtE=
Subject: Re: [PATCH] Add quick erase format option
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stefani Seibold <stefani@seibold.net>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Enzinger, Robert (EXT-Other - DE/Munich)" 
	<robert.enzinger.ext@nsn.com>
In-Reply-To: <1283410392.6920.36.camel@wall-e.seibold.net>
References: <1281342353-18180-1-git-send-email-stefani@seibold.net>
	 <1281343038.12908.25.camel@localhost>
	 <1281343974.18398.13.camel@wall-e.seibold.net>
	 <1281353344.2332.8.camel@brekeke>
	 <1281362069.20181.16.camel@wall-e.seibold.net>
	 <1283081435.2131.24.camel@brekeke>
	 <1283236978.6083.28.camel@wall-e.seibold.net>
	 <1283302043.2018.92.camel@brekeke>
	 <1283410392.6920.36.camel@wall-e.seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 13:58:20 +0300
Message-ID: <1283425100.3085.5.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 08:53 +0200, Stefani Seibold wrote: 
> --do-not-use-me is the best. But more seriously i think we should it
> split it into two options. --all-erased and --check-erased. The first
> assumes that all PEB are erased, while the second do the check if the
> PEB is erased and if not it will be erased.
> 
> So we can handle NAND's, which have a fast erase, and NOR's  which are
> very slow. With this we are able to pick the best option for the
> manufacturing.

I am fine with checking, but what bothers me is that you check only 64
bytes out of 128KiB - why this is enough to make sure the eraseblock is
erased?

Probably it is ok for you, but in for general use-case this is wrong,
even checking all 128KiB is wrong, because of the unstable bits.

What I think will make more sense is to add general option --verify or
something like that. It would read everything the utility wrote and
verify it is identical to what was written. Probably this can be done in
libmtd.

Then you will be able to combine --all-erased with --verify and achieve
what you want.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)


