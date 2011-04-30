Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761176Ab1D3BmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 21:42:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55380 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab1D3BmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 21:42:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-pgp-id:x-archive
         :user-agent;
        b=WAhWBIkMAErgB6iegxpegT3Mu60qXs2DNc7TtI/udQ6MumA6Im89AcPPJwRBsA2RhC
         qezRAOBSKWj7MowHnF1Yqf1AxtPmQnz9kcRfbwqMnt5vQJQ5g+2SVXQvSIvivtPZDVr4
         91NU0fkfsw0pzb0lEbjKs8YxUL5vQdH2cPmdg=
Date: Sat, 30 Apr 2011 03:41:57 +0200
From: clemens fischer <ino-news@spotteswoode.dnsalias.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, wlanfae@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
Message-ID: <20110430014157.GB3719@spotteswoode.de.eu.org>
References: <4db8436a.NDzkd3ql2wJdwy2L%Larry.Finger@lwfinger.net>
 <20110428150819.GA3713@spotteswoode.de.eu.org>
 <4DB9884F.10409@lwfinger.net>
 <BANLkTin7Nw1ZjK8UHfypHXY5ZuzafXnJbQ@mail.gmail.com>
 <20110428201527.GA3738@spotteswoode.de.eu.org>
 <BANLkTimi4cUzS5-r_ofzLnjbVtNNjwD69Q@mail.gmail.com>
 <20110429211548.GA4351@spotteswoode.de.eu.org>
 <BANLkTi=-4NaMCMEDxj3CVg6iAmS3DGm0Qw@mail.gmail.com>
 <20110429222548.GC4351@spotteswoode.de.eu.org>
 <BANLkTimK-i7aBrFJjGfxQkz-YkLd-ftCnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimK-i7aBrFJjGfxQkz-YkLd-ftCnA@mail.gmail.com>
X-PGP-ID: 0x214190AF
X-Archive: encrypt=none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jeff Chua:

> On Sat, Apr 30, 2011 at 6:25 AM, clemens fischer
> <ino-news@spotteswoode.dnsalias.org> wrote:
> > whereas "r8712u" has only DHCP offers in the logs but no ACKs.
>
> Are you saying you're seeing dhcpd being offered in the log? Please
> post the log from the time your mobile starts up the r8712u.

Presently I cannot reproduce this peculiar situation.  The win-CE device
provides next to nothing regarding helpful logs, but I know that it said
"connected" at various occasions without any link being active.  Also,
it seems DHCP leases are not verified, instead the remaining lease time
being taken for granted.

The only thing I can present are the following link-level messages from
an unsuccessful attempt using "r8712u" (sorry for the overlong lines):

2011-04-30_03:18:07 + exec /command/chpst -v -m 11333000 /usr/sbin/tcpdump -v -e -n -l -t -i wlan0 -Z nobody -s 512
2011-04-30_03:18:07 tcpdump: listening on wlan0, link-type EN10MB (Ethernet), capture size 512 bytes
2011-04-30_03:18:07 00:22:43:4e:2a:82 > ff:ff:ff:ff:ff:ff, 802.3, length 126: LLC, dsap RS511 (0x4e) Group, ssap Unknown (0x8c) Command, ctrl 0x1b: Unnumbered, 0b, Flags [Poll], length 112
2011-04-30_03:18:07 00:22:43:4e:2a:82 > ff:ff:ff:ff:ff:ff, 802.3, length 58: LLC, dsap Unknown (0x52) Individual, ssap Unknown (0xfc) Command, ctrl 0x0059: Supervisory, Reject, rcv seq 0, Flags [Command], length 44
2011-04-30_03:18:08 00:22:43:4e:2a:82 > 33:33:00:01:00:03, 802.3, length 101: LLC, dsap Unknown (0x5a) Group, ssap Unknown (0xee) Response, ctrl 0x2f: Unnumbered, 2f, Flags [Response], length 87
2011-04-30_03:18:08 00:22:43:4e:2a:82 > 33:33:00:00:00:02, 802.3, length 102: LLC, dsap Unknown (0x60) Group, ssap Unknown (0xf6) Response, ctrl 0x002d: Supervisory, ?, rcv seq 0, Flags [Response], length 88
2011-04-30_03:18:08 00:22:43:4e:2a:82 > ff:ff:ff:ff:ff:ff, 802.3, length 58: LLC, dsap Unknown (0x62) Individual, ssap Unknown (0x16) Command, ctrl 0xeb: Unnumbered, eb, Flags [Command], length 44
2011-04-30_03:18:09 00:22:43:4e:2a:82 > 33:33:00:01:00:03, 802.3, length 101: LLC, dsap Unknown (0x6a) Group, ssap Unknown (0x16) Response, ctrl 0x007a: Information, send seq 61, rcv seq 0, Flags [Response], length 87
2011-04-30_03:18:09 00:22:43:4e:2a:82 > 33:33:ff:4e:2a:82, 802.3, length 102: LLC, dsap Unknown (0x78) Individual, ssap Unknown (0xe4) Response, ctrl 0x0099: Supervisory, Reject, rcv seq 0, Flags [Response], length 88
2011-04-30_03:18:10 00:22:43:4e:2a:82 > 33:33:00:00:00:02, 802.3, length 86: LLC, dsap Unknown (0x88) Individual, ssap Unknown (0x18) Command, ctrl 0x0036: Information, send seq 27, rcv seq 0, Flags [Command], length 72
2011-04-30_03:18:11 00:22:43:4e:2a:82 > 33:33:00:01:00:03, 802.3, length 101: LLC, dsap Unknown (0x8a) Individual, ssap Unknown (0xc0) Command, ctrl 0x0060: Information, send seq 48, rcv seq 0, Flags [Command], length 87
2011-04-30_03:18:12 00:22:43:4e:2a:82 > 33:33:00:01:00:03, 802.3, length 102: LLC, dsap Unknown (0xa0) Group, ssap Unknown (0x80) Command, ctrl 0x004a: Information, send seq 37, rcv seq 0, Flags [Command], length 88
2011-04-30_03:18:15 00:22:43:4e:2a:82 > 33:33:00:00:00:02, 802.3, length 86: LLC, dsap Unknown (0xc6) Group, ssap RS511 (0x4e) Response, ctrl 0xd3: Unnumbered, c3, Flags [Final], length 72
2011-04-30_03:18:16 00:22:43:4e:2a:82 > 33:33:00:01:00:03, 802.3, length 102: LLC, dsap Unknown (0xd6) Individual, ssap Unknown (0x8c) Response, ctrl 0x43: Unnumbered, disc, Flags [Response], length 88
2011-04-30_03:18:21 00:22:43:4e:2a:82 > ff:ff:ff:ff:ff:ff, 802.3, length 358: LLC, dsap Unknown (0x2c) Individual, ssap Unknown (0x74) Response, ctrl 0xe3: Unnumbered, test, Flags [Response], length 344
2011-04-30_03:18:22 00:22:43:4e:2a:82 > ff:ff:ff:ff:ff:ff, 802.3, length 358: LLC, dsap Unknown (0x3a) Group, ssap Unknown (0x84) Response, ctrl 0x009e: Information, send seq 79, rcv seq 0, Flags [Response], length 344
2011-04-30_03:18:25 00:22:43:4e:2a:82 > ff:ff:ff:ff:ff:ff, 802.3, length 358: LLC, dsap Unknown (0x62) Group, ssap Null (0x00) Command, ctrl 0xcf: Unnumbered, cf, Flags [Command], length 344
2011-04-30_03:18:29 00:22:43:4e:2a:82 > ff:ff:ff:ff:ff:ff, 802.3, length 358: LLC, dsap Unknown (0x9e) Group, ssap Unknown (0x3a) Response, ctrl 0x0038: Information, send seq 28, rcv seq 0, Flags [Response], length 344
2011-04-30_03:18:56 00:22:43:4e:2a:82 > ff:ff:ff:ff:ff:ff, 802.3, length 108: LLC, dsap Unknown (0x38) Group, ssap Unknown (0xba) Response, ctrl 0x0052: Information, send seq 41, rcv seq 0, Flags [Response], length 94
2011-04-30_03:18:56 00:22:43:4e:2a:82 > 33:33:00:01:00:03, 802.3, length 106: LLC, dsap Unknown (0x3a) Individual, ssap Unknown (0x26) Response, ctrl 0x0068: Information, send seq 52, rcv seq 0, Flags [Response], length 92
2011-04-30_03:18:56 00:22:43:4e:2a:82 > ff:ff:ff:ff:ff:ff, 802.3, length 108: LLC, dsap Unknown (0x3c) Group, ssap Unknown (0x28) Command, ctrl 0x002d: Supervisory, ?, rcv seq 0, Flags [Command], length 94
2011-04-30_03:18:56 00:22:43:4e:2a:82 > 33:33:00:01:00:03, 802.3, length 109: LLC, dsap Unknown (0x3c) Group, ssap Unknown (0x3c) Command, ctrl 0x00d2: Information, send seq 105, rcv seq 0, Flags [Command], length 95
2011-04-30_03:18:57 00:22:43:4e:2a:82 > ff:ff:ff:ff:ff:ff, 802.3, length 108: LLC, dsap Unknown (0x48) Individual, ssap Unknown (0xf2) Command, ctrl 0x23: Unnumbered, 23, Flags [Command], length 94
2011-04-30_03:18:57 00:22:43:4e:2a:82 > 33:33:00:01:00:03, 802.3, length 106: LLC, dsap Unknown (0x48) Group, ssap Unknown (0x5c) Response, ctrl 0xd3: Unnumbered, c3, Flags [Final], length 92
2011-04-30_03:18:57 00:22:43:4e:2a:82 > ff:ff:ff:ff:ff:ff, 802.3, length 108: LLC, dsap Unknown (0x4c) Individual, ssap Unknown (0x46) Command, ctrl 0xc3: Unnumbered, c3, Flags [Command], length 94
2011-04-30_03:18:57 00:22:43:4e:2a:82 > 33:33:00:01:00:03, 802.3, length 109: LLC, dsap Unknown (0x4c) Individual, ssap Unknown (0x50) Command, ctrl 0x0015: Supervisory, Receiver not Ready, rcv seq 0, Flags [Command], length 95
2011-04-30_03:18:58 00:22:43:4e:2a:82 > ff:ff:ff:ff:ff:ff, 802.3, length 108: LLC, dsap Unknown (0x5c) Individual, ssap Unknown (0xda) Response, ctrl 0x00a1: Supervisory, Receiver Ready, rcv seq 0, Flags [Response], length 94
2011-04-30_03:18:58 00:22:43:4e:2a:82 > 33:33:00:01:00:03, 802.3, length 111: LLC, dsap Unknown (0x5c) Individual, ssap Unknown (0xee) Command, ctrl 0x00ad: Supervisory, ?, rcv seq 0, Flags [Command], length 97
2011-04-30_03:18:59 00:22:43:4e:2a:82 > ff:ff:ff:ff:ff:ff, 802.3, length 108: LLC, dsap Unknown (0x6c) Individual, ssap IP (0x06) Response, ctrl 0x03: Unnumbered, ui, Flags [Response], length 94
2011-04-30_03:18:59 00:22:43:4e:2a:82 > 33:33:00:01:00:03, 802.3, length 111: LLC, dsap Unknown (0x6c) Individual, ssap Unknown (0x10) Command, ctrl 0x0081: Supervisory, Receiver Ready, rcv seq 0, Flags [Command], length 97


regards, clemens
