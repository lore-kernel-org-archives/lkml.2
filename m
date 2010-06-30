Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab0F3XLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 19:11:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755348Ab0F3XLC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 19:11:02 -0400
MIME-Version: 1.0
In-Reply-To: <20100630211516.GA25991@us.ibm.com>
References: <20100630211516.GA25991@us.ibm.com>
Date: Wed, 30 Jun 2010 16:10:26 -0700
Message-ID: <AANLkTin6_LbGwRZm3GPDnyNb36v8G4DHqGno1mEXjmV0@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] PCI: skip release and reallocation of io port 
	resources
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       clemens@ladisch.de, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 2:15 PM, Ram Pai <linuxram@us.ibm.com> wrote:
>       PCI: skip release and reallocation of io port resources

Gaah. This still looks like just total ad-hoc hackery. The logic for
it all seems very fragile, just a random case made up from the one
failing issue. There's no underlying logic or design to it.

I still think that we should just make people explicitly ask for a
blank slate if the bios allocations don't work out. Rather than trying
to fix it up automatically, which has been a total rats nest of random
crud.

             Linus
