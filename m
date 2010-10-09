Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab0JIHeG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 03:34:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43557 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab0JIHeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 03:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=QpXgAWvMrmP1MHbptKqht5MvMb+fKYYSV9/1TKwD+LPA1vG/dcmaCiNpo5+v3YXSk9
         GIilZMQK2EfBiwWlqshk2Scg0fDHLdVmog+3dHyluEKSELlUo+N0bTp7ttL8ilk0vSYF
         pZkwQQfjxyX4g2KpVrjAZ3TZs/EJDKJkw1x48=
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Roaming / offchannel enhancements for broadcast / multicast frames
Date: Sat, 9 Oct 2010 09:33:12 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.3-desktop; KDE/4.5.1; x86_64; ; )
Cc: Paul Stewart <pstew@google.com>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Matt Smith <Matt.Smith@atheros.com>,
        Srinivasa Duvvuri <Srinivasa.Duvvuri@atheros.com>,
        Carolyn Waller <Carolyn.Waller@atheros.com>,
        Amod Bodas <Amod.Bodas@atheros.com>,
        David Quan <David.Quan@atheros.com>,
        Bennyam Malavazi <Bennyam.Malavazi@atheros.com>,
        Cliff Holden <Cliff.Holden@atheros.com>,
        Aeolus Yang <Aeolus.Yang@atheros.com>, Kevin Hayes <kevin@atheros.com>
References: <AANLkTin9AwTa8x6faFEXBbrGZa4mg3AeDfeEmmdaF9_d@mail.gmail.com> <AANLkTika+07mD==fPioanurwD-_s8aaJFc+nb4ZZOL0J@mail.gmail.com> <AANLkTimBXC9P7pf+-szK3A5FoS2Sjndr8AB9JR=7V-Sr@mail.gmail.com>
In-Reply-To: <AANLkTimBXC9P7pf+-szK3A5FoS2Sjndr8AB9JR=7V-Sr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010090933.13008.helmut.schaa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 09 Oktober 2010 schrieb Luis R. Rodriguez: 
> > There's an additional issue about what happens
> > when we are in the middle of a bgscan and new tx traffic appears.
> 
> We can force going back on channel in this case I think.

This already happens (scan.c):

523                 if (associated && ( !tx_empty || bad_latency ||
524                     listen_int_exceeded))
525                         local->next_scan_state = SCAN_ENTER_OPER_CHANNEL;
526                 else
527                         local->next_scan_state = SCAN_SET_CHANNEL;

When the currently scanned channel is finished and tx traffic arrived
mac80211 will switch back to the operating channel. However, this doesn't
immediately switch back but waits for the channel scan to be completed.
