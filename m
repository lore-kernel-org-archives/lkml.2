Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab0KYQZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:25:45 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:42143 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab0KYQZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:25:44 -0500
From: nisse@lysator.liu.se (Niels =?iso-8859-1?Q?M=F6ller?=)
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: TCP_MAXSEG vs TCP/generic segmentation offload (tso/gso)
References: <nny68hqzzn.fsf@stalhein.lysator.liu.se>
	<1290695253.2858.336.camel@edumazet-laptop>
	<nnaakxqw1u.fsf@stalhein.lysator.liu.se>
	<1290698312.2858.341.camel@edumazet-laptop>
Date: Thu, 25 Nov 2010 17:25:42 +0100
In-Reply-To: <1290698312.2858.341.camel@edumazet-laptop> (Eric Dumazet's
	message of "Thu, 25 Nov 2010 16:18:31 +0100")
Message-ID: <nn1v69qsjd.fsf@stalhein.lysator.liu.se>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (usg-unix-v)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> I believe TCP_MAXSEG is working fine, but GRO/GSO dont care at all :
> They coalesce frames whatever their size is.

I was under the impression that TSO (and maybe GSO) implied more
cleverness in the network card; that the network card more or less gets
to decide by itself how to divide a tcp stream into segments. And for
example in the atl1c driver which I looked a bit into, this was what the
REG_MTU register was for. Seems I have gotten this totally wrong.

Maybe Documentation/networking/netdevices.txt could clarify how it
works. Currently, it says

: Segmentation Offload (GSO, TSO) is an exception to this rule.  The
: upper layer protocol may pass a large socket buffer to the device
: transmit routine, and the device will break that up into separate
: packets based on the current MTU.

Regards, and thanks for your patience,
/Niels

-- 
Niels Möller. PGP-encrypted email is preferred. Keyid C0B98E26.
Internet email is subject to wholesale government surveillance.
