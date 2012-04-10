Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab2DJN4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:56:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38711 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab2DJN4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:56:43 -0400
Message-ID: <4F843C17.5050004@kernel.dk>
Date: Tue, 10 Apr 2012 15:56:39 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH] block: Change default IO scheduler to deadline except
 SATA
References: <20120410133708.GE21801@redhat.com>
In-Reply-To: <20120410133708.GE21801@redhat.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-10 15:37, Vivek Goyal wrote:
> Hi,
> 
> I am wondering if CFQ as default scheduler is still the right choice. CFQ
> generally works well on slow rotational media (SATA?). But often
> underperforms on faster storage (storage arrays, PCIE SSDs, virtualized
> disk in linux guests etc). People often put logic in user space to tune their
> systems and change IO scheduler to deadline to get better performance on
> faster storage.
> 
> Though there is not one good answer for all kind of storage and for all
> kind of workloads, I am wondering if we can provide a better default and
> that is change default IO scheduler to "deadline" except SATA.
> 
> One can argue that some SAS disks can be slow too and benefit from CFQ. Yes,
> but default IO scheduler choice is not perfect anyway. It just tries to
> cater to a wide variety of use cases out of the box.
> 
> So I am throwing this patch out see if it flies. Personally, I think it
> might turn out to be a more reasonable default.

I think it'd be a lot more sane to just use CFQ on rotational single
devices, and default to deadline on raid or non-rotational devices. This
still isn't perfect, since less worthy SSDs still benefit from the
read/write separation, and some multi device configs will be faster as
well. But it's better.

The below patch is not a good idea. There's no clear distinction between
on what CFQ is now the default.

-- 
Jens Axboe

