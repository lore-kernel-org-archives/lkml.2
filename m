Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab1CHQjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 11:39:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45825 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1CHQjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 11:39:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Bf1lNZMe8ejP4tK9KmDceuyb6gac3GVcXvF/CBB1QrOJAEFSnlpcZwrVxXGHRMSmyu
         F686UD+CE2TJ0KGI5TMzcS8FHJNZg54zXz+E6XoWr4ze2TM6Jf8GZk2uYkNcfpiJtjP3
         bxe+Z5vT+64p4KycL2+z0tXGdGGvzRv84b5VQ=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1103081203260.2968@kaball-desktop>
References: <alpine.DEB.2.00.1103011517280.2917@kaball-desktop>
	<4D6D6980.7060304@kernel.org>
	<alpine.DEB.2.00.1103071527500.2968@kaball-desktop>
	<AANLkTi=aUGdjvtvy81FimMZB5PZNzASXHN0BZHWHUuLs@mail.gmail.com>
	<alpine.DEB.2.00.1103081203260.2968@kaball-desktop>
Date: Tue, 8 Mar 2011 08:39:03 -0800
X-Google-Sender-Auth: 6Uo_ErtDeL95pP5z2rRh40NH9NE
Message-ID: <AANLkTikmiKvdgzE_G1-w7PBqBf=kD5R5k5QZChHeiDCd@mail.gmail.com>
Subject: Re: "x86-64, mm: Put early page table high" causes crash on Xen
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 4:14 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
>> > [    0.000000] DEBUG alloc low page(cf965000, 00001000)
>>
>> these are not mapped yet, and need to use early_ioremap.
>
> In fact we are mapping them inside alloc_low_page. No need for
> map_low_page, right?

alloc_low_page return virtual address, but it can not be used to
access that position right away.
so in that case map_low_page is used to convert that virtual address
to phy address and then to early map address.

Yinghai
