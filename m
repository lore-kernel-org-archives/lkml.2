Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab1JVKY0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 06:24:26 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:47370 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab1JVKYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 06:24:25 -0400
Date: Sat, 22 Oct 2011 12:24:27 +0200
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
        Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Keyboard and mouse issues on MacBook Air (4,2)
Message-ID: <20111022102427.GB26724@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
References: <20111017175906.GA3461@schottelius.org>
 <alpine.LRH.2.00.1110172015050.3869@twin.jikos.cz>
 <20111017214050.GA1408@schottelius.org>
 <20111019150122.GA6157@schottelius.org>
 <alpine.LNX.2.00.1110191702470.3541@pobox.suse.cz>
 <20111019210742.GA2432@schottelius.org>
 <20111022020205.GA26724@schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111022020205.GA26724@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.1.0-rc6-g443452b x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm making progress in this issue:

I've just grabbed the whole list of manuals for all MacBook Airs from the Apple page
and had a look at the keyboard layout in the manual:

air 2008: new

13" air late 2010: old
11" air late 2010: old

11" air mid 2011: new
13" air mid 2011: new

table_new = with keyboard backlight keys, f5 mapped to backlight down -> apple_fn_keys
table_old = f5 has no fn-special meaning -> macbookair_fn_keys

Reviewing drivers/hid/hid-apple.c you were absolutely right, the
apple_fn_keys[] maps correctly.

The missing bit to correct my previous patch: To which device IDs do the devices 
named above match to? I.e. is USB_DEVICE_ID_APPLE_WELLSPRING6_* the
MacBook Air 4,2?

Cheers,

Nico

p.s.: sorry for the noise, was a bit confused.

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
