Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab0EZTPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:15:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46593 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab0EZTPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:15:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=wmmgt9XyYlOwaJdjBAQHgSJN0kKw3O1UQ7luO8OKxQcktQxG2mfYK7dQZRa/CkUXdz
         KiDv8i0HGHAb4IUwr+8l0ZH9TGnw6snllVjafNfCkFTO0xdR2QJPKzxKdt/n9TrR1Lx/
         pPIgrpKxSufCuMymtipG+ZT1SBFUpasqFdDag=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 7/17] arch/arm/common: Add missing spin_unlock_irqrestore
Date: Wed, 26 May 2010 21:13:37 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33-2-amd64; KDE/4.4.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Julia Lawall <julia@diku.dk>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1005261756000.23743@ask.diku.dk> <201005261907.06198.marek.vasut@gmail.com> <20100526184358.GC6232@n2100.arm.linux.org.uk>
In-Reply-To: <20100526184358.GC6232@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005262113.38450.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne St 26. května 2010 20:43:58 Russell King - ARM Linux napsal(a):
> On Wed, May 26, 2010 at 07:07:06PM +0200, Marek Vasut wrote:
> > Why are "readl"s protected by spinlock anyway ? Can't we just move the
> > locking past the code above ?
> 
> Good question - and there seems to be a deadlock waiting to happen -
> sa1111_wake() re-takes the same lock.
> 
> I think we should kill all the spinlock in sa1111_resume().

Russell, Julia, check the patch I posted. Comments are welcome.

btw. Russell, killing the spinlock in resume might be overkill. If there was any 
reason for that being there, it was for the write ops so I'd rather keep those 
locked. Anyone with actual hardware available should look into that though.
