Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2BBPv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 10:51:26 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42055 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab2BBPvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 10:51:25 -0500
Message-ID: <4F2AB0F8.5020207@garzik.org>
Date: Thu, 02 Feb 2012 10:51:20 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeff Law <law@redhat.com>, David Miller <davem@davemloft.net>,
        matz@suse.de, jkosina@suse.cz, walters@verbum.org, jack@suse.cz,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        dsterba@suse.cz, ptesarik@suse.cz, rguenther@suse.de, gcc@gcc.gnu.org
Subject: Re: Memory corruption due to word sharing
References: <CA+55aFxmdskUXX1iBaPx7rUGD95UqNJxhe1BLeVtZjqHjBpsPA@mail.gmail.com> <alpine.LRH.2.00.1202011808240.22725@twin.jikos.cz> <Pine.LNX.4.64.1202011818570.25409@wotan.suse.de> <20120201.130905.1131458895704793597.davem@davemloft.net> <4F298865.5000409@redhat.com> <CA+55aFzzaWM=EWsK1hRho27b5ePEYNkzEnqce-DmCQ3kL1w9ZA@mail.gmail.com>
In-Reply-To: <CA+55aFzzaWM=EWsK1hRho27b5ePEYNkzEnqce-DmCQ3kL1w9ZA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 02:09 PM, Linus Torvalds wrote:
> We have a lot of code, there's still a lot of situations left where
> bitfields are just really convenient.

Or even just s/convenient/ingrained habit/   As much as I try to avoid 
bitfields, engineers writing vendor drivers love to lay out their 
hardware structures using bitfields, leading to such crapola as

	#ifdef little endian
		a bunch of bitfields, LE arrangement
	#else
		bitfields, now in BE arrangement
	#endif

This crops up again and again in drivers :/

	Jeff


