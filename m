Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab2HCGdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 02:33:42 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:56678
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843Ab2HCGdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 02:33:40 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q736XNwA008356
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Rob Landley <rob@landley.net>, Milton Miller <miltonm@bga.com>,
        Borislav Petkov <bp@alien8.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jan Engelhardt <jengelh@inai.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] netconsole.txt: "nc" needs "-p" to specify the listening port
In-Reply-To: <CAM_iQpWoKGJTUjohn9_guktpBNbOazKY1_eUQozz_O6ZkRmyPg@mail.gmail.com>
	(Cong Wang's message of "Fri, 3 Aug 2012 13:30:19 +0800")
References: <gilii4nnxb.fsf@mx10.gouders.net> <kernel-nc-hints@mdm.bga.com>
	<501937F7.2070600@landley.net> <gi3946lin5.fsf@mx10.gouders.net>
	<gisjc5hvun.fsf@mx10.gouders.net>
	<CAM_iQpWoKGJTUjohn9_guktpBNbOazKY1_eUQozz_O6ZkRmyPg@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Fri, 03 Aug 2012 08:33:21 +0200
Message-ID: <giobmsiixa.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Fri, 03 Aug 2012 08:33:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Fri, Aug 3, 2012 at 4:39 AM, Dirk Gouders
> <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
>>
>> From d756d2750e4cf07d3c0942dc3c491d57631d4338 Mon Sep 17 00:00:00 2001
>> From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
>> Date: Thu, 2 Aug 2012 22:20:16 +0200
>> Subject: [PATCH] netconsole.txt: revision of examples for the receiver of kernel messages
>>
>> There are at least 4 implementations of netcat with the BSD-based
>> being the only one that has to be used without the -p switch to
>> specify the listening port.
>>
>> Jan Engelhardt suggested to add an example for socat(1).
>
>
> Looks good, but you missed your SOB.

Thanks for noticing that, attached is the amended patch.

Dirk

>From b3aec70d785d338b1b643fece6606cd32addaf0c Mon Sep 17 00:00:00 2001
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Date: Thu, 2 Aug 2012 22:20:16 +0200
Subject: [PATCH] netconsole.txt: revision of examples for the receiver of kernel messages

There are at least 4 implementations of netcat with the BSD-based
being the only one that has to be used without the -p switch to
specify the listening port.

Jan Engelhardt suggested to add an example for socat(1).

Signed-off-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
---
 Documentation/networking/netconsole.txt |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/netconsole.txt b/Documentation/networking/netconsole.txt
index 8d02207..2e9e0ae2 100644
--- a/Documentation/networking/netconsole.txt
+++ b/Documentation/networking/netconsole.txt
@@ -51,8 +51,23 @@ Built-in netconsole starts immediately after the TCP stack is
 initialized and attempts to bring up the supplied dev at the supplied
 address.
 
-The remote host can run either 'netcat -u -l -p <port>',
-'nc -l -u <port>' or syslogd.
+The remote host has several options to receive the kernel messages,
+for example:
+
+1) syslogd
+
+2) netcat
+
+   On distributions using a BSD-based netcat version (e.g. Fedora,
+   openSUSE and Ubuntu) the listening port must be specified without
+   the -p switch:
+
+   'nc -u -l -p <port>' / 'nc -u -l <port>' or
+   'netcat -u -l -p <port>' / 'netcat -u -l <port>'
+
+3) socat
+
+   'socat udp-recv:<port> -'
 
 Dynamic reconfiguration:
 ========================
-- 
1.7.8.6

