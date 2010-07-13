Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab0GMLv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 07:51:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54335 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab0GMLv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 07:51:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the rr tree with the sound tree
Date: Tue, 13 Jul 2010 13:51:54 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
References: <20100713121348.c9e76987.sfr@canb.auug.org.au>
In-Reply-To: <20100713121348.c9e76987.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007131351.54246.arnd@arndb.de>
X-Provags-ID: V02:K0:+2Q1wAk/vYYEblFSJj7MjmXuGGtYiGZvEVq4nxj9u3u
 VHhm4AlpCxG7RIkW/92MtYyNJKoJBzuGVrt0WlX254fTDv9ELM
 MlhG3vBEoaeHcT/WEVH8693n/YJXRIonifOAeUErfgsORi101x
 cYU6ai8EWplK1Gua8xhFET4RqXPj7SKTV4GT1Km/9F+DntjLtQ
 7eoRIhnSZGN/hg/+C1BxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 July 2010, Stephen Rothwell wrote:
> Overlapping additions.  I fixed it up (see below) and carry the fix as necessary.
> 
> I was not sure if the kparam_(un)block_sysfs_write() calls needed to be
> surrounded by the (un)lock_kernel() calls or vice verse.

Either way should be fine, since the BKL does not suffer from AB-BA deadlocks
with mutexes. I would generally recommend making the BKL the outermost
lock to make it easier to conver to a mutex. That is how you did it too.

Thanks,

	Arnd
