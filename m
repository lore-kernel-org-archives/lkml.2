Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab1FOIMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 04:12:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43248 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab1FOIMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 04:12:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:date:content-type:x-mailer
         :content-transfer-encoding:message-id:mime-version;
        b=nfeGnEkDKc9asLZlngo0DkpfRy+FSu04D6Kuw5pYPwjbw5CHhMIeM/w50x0oJAoRBI
         /dq1bk/Al9PnEWP3n2BedO2ReaAa+k+W8TfjI+CeInR0YKOAaxtHraFr7KhCBqhqbNm+
         WJAGDOmlXyG42TqiGSRslu8YWO38pGDvFx9zA=
Subject: tc match MAC destination
From: Andrei Popa <ierdnah@gmail.com>
Reply-To: ierdnah@gmail.com
To: linux-kernel@vger.kernel.org
Cc: pdoru.kernel@evox.ro, netdev@vger.kernel.org
Date: Wed, 15 Jun 2011 11:12:01 +0300
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.0.2 
Content-Transfer-Encoding: 7bit
Message-ID: <1308125523.30324.64.camel@ierdnac-hp>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I want to shape PVSTP+ traffic (traffic that has MAC destination
01:00:0c:cc:cc:cd) and it doesn't work.
I've tried
filter parent 1: protocol 802_3 pref 2 u32 fh 802::11 order 17 key ht
802 bkt 0 flowid 1:3 
  match 01000ccc/ffffffff at 0
but it doesn't work.

With
filter parent 1: protocol arp pref 1 u32 
filter parent 1: protocol arp pref 1 u32 fh 801: ht divisor 1 
filter parent 1: protocol arp pref 1 u32 fh 801::7 order 7 key ht 801
bkt 0 flowid 1:3 
  match 00000000/00000000 at 0
filter parent 1: protocol 802_3 pref 2 u32 
filter parent 1: protocol 802_3 pref 2 u32 fh 802: ht divisor 1 
filter parent 1: protocol 802_3 pref 2 u32 fh 802::3 order 3 key ht 802
bkt 0 flowid 1:3 
  match 00000000/00000000 at 0
        action order 1: mirred (Egress Mirror to device ifb1) pipe
        index 1923 ref 1 bind 1

I see arp trafic with tcpdump on ifb1, but no STP traffic or any kind of
traffic except arp, because I've matched all MAC addreses.
Can somebody verify that this match works ?

I use kernel 2.6.39.1.

Thank you,
-- 
Andrei Popa
0760 683 280



