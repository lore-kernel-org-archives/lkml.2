Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab0LQAPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:15:52 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:45686 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab0LQAPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:15:51 -0500
Message-ID: <4D0AABB3.7050404@psi5.com>
Date: Fri, 17 Dec 2010 01:15:47 +0100
From: Christian Brandt <brandtc@psi5.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ric Wheeler <ricwheeler@gmail.com>, linux-kernel@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: swap storage alignment and stride size
References: <4CFFBA7D.6060802@psi5.com> <4CFFE2EA.9040909@gmail.com> <yq1d3p486qe.fsf@sermon.lab.mkp.net> <alpine.LSU.2.00.1012142038430.13004@tigran.mtv.corp.google.com> <yq18vzq6dgb.fsf@sermon.lab.mkp.net> <alpine.LSU.2.00.1012151627400.8734@tigran.mtv.corp.google.com>
In-Reply-To: <alpine.LSU.2.00.1012151627400.8734@tigran.mtv.corp.google.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.12.2010 01:42, schrieb Hugh Dickins:

> No, the 4k-aligned remains 4k-aligned, of course.  But if you aligned
> your swap partition on, say, a 1MB boundary, and are thinking of
> working in aligned 1MB blocks, then it may be awkward that there's
> always this special 4k at the start (it could be written back each
> time even though it hasn't changed, but it's still an odd case).

Hallo Hugh, I stayed a bit quit after my question to see what people
think. So I wasn't wrong from the start, neither kernel nor userland
tools care for anything beyond page size today. For today I'll be happy
enough with the status quo

Though I have a clear vision what I would like:

The kernel needs to be prepared to handle larger groups of pages.
In a perfect world it would favorite larger operations whicha are
already aligned to underlying architectures.
Eg, lets first write that very big 8192kiB chunk which is perfectly
aligned. But ignore the small pieces scattered around memory below the
chunk size until memory gets really low.
Small pieces don't eat up much memory any.
May it would even help to swap out only chunk-aligned parts even when
there are small pre- and post-data around the big chunk.

Also I would expect a userspace tool to setup a swap space with
alternate settings (e.g. offset to device start, chunk size, alignment)
- a nice new role for mkswap?

The chunk size shouldn't be any fixed value.
Often I have 64k, sometimes 256k, rarelly even 4096kiB.
And you never know what strange layouts are luring around the next
corner, maybe in 2015 we will all use SSD drives with a cell size of
12288kByte, already today several budget SSDs have pretty strange cell
sizes:
My cheapish Acer 24giB drive has 384kiB because it has connected three
8giB flash chips to the four channel controler with the fourth channel
being broken/disabled...

-- 
Christian Brandt
