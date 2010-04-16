Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab0DPXlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 19:41:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48979 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab0DPXlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 19:41:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=NNGGD2UVbRo40iyASnRweRB47gPGZrFkk6NMcAxgoaQbKdcdJD7tjNerq1qRXc/0eu
         BV2avP4rpkw5Rud+8bqohe5/P5y3UFbufAgaEK5r9ai7R38aXsko6W8mOPZsxOJNIixX
         Sf9/EzuStfQOLVgOHbaoToQq+xY19VxbpbZkw=
MIME-Version: 1.0
In-Reply-To: <41b2cd7e8bacd38bb9c997b7197e175d727876f9.1271406290.git.mina86@mina86.com>
References: <cover.1271406290.git.mina86@mina86.com> <0d8cfc5167bbcbfc6c5ae0ab10980eba743e0cee.1271406290.git.mina86@mina86.com> 
	<7fbfe9c15eae523b73b704a3b5399319152fd505.1271406290.git.mina86@mina86.com> 
	<41b2cd7e8bacd38bb9c997b7197e175d727876f9.1271406290.git.mina86@mina86.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 16 Apr 2010 19:40:50 -0400
Message-ID: <n2v8bd0f97a1004161640q640bade7xd4887dde5921b79e@mail.gmail.com>
Subject: Re: [PATCH 3/8] USB: gadget: __init and __exit tags removed
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 05:49, Michal Nazarewicz wrote:
> __init, __initdata and __exit tags have have been removed from
> various files to make it possible for gadgets that do not use
> the __init/__exit tags to use those.
>
> Files in question are related to:
> * the core composite framework,
> * the mass storage function (fixing a section mismatch) and
> * ethernet driver (ACM, ECM, RNDIS).

it would be nice if the expected behavior were documented somewhere so
we dont have to keep thrashing the section markings on the gadget
drivers.  first they get marked to save space for setups where it
makes no sense to keep the functions.  then they get tweaked to
support a semi-dynamic state.  now they're all removed to support yet
a different setup.

sounds like the system is insufficiently flexible to meet the
realistic needs of different groups.
-mike
