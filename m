Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab2G1LId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 07:08:33 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:37592
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427Ab2G1LIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 07:08:31 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q6SB8J18006902
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] netconsole.txt: "nc" needs "-p" to specify the listening port
In-Reply-To: <20120727131535.GA3485@x1.osrc.amd.com> (Borislav Petkov's
	message of "Fri, 27 Jul 2012 15:15:36 +0200")
References: <gir4rxk7c2.fsf@mx10.gouders.net>
	<CAM_iQpX3EFnoW=Vh2hgJwNPr-whJhcUctCyv_+afFB8DrnHRsQ@mail.gmail.com>
	<gihastk13u.fsf@mx10.gouders.net>
	<20120727131535.GA3485@x1.osrc.amd.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Sat, 28 Jul 2012 13:08:16 +0200
Message-ID: <gilii4nnxb.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Sat, 28 Jul 2012 13:08:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@alien8.de> writes:

> On Fri, Jul 27, 2012 at 11:24:53AM +0200, Dirk Gouders wrote:
>> Cong Wang <xiyou.wangcong@gmail.com> writes:
>> 
>> > On Fri, Jul 27, 2012 at 2:35 PM, Dirk Gouders
>> > <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
>> >> Hi Jesse,
>> >>
>> >> I would like to ask you to check if the documentation of "nc" in
>> >> netconsole.txt is still correct.  I tried two different netcat packages
>> >> and both require "-p" to specify the listening port.  I am wondering if
>> >> that changed after the use of "nc" has been documented.
>> >
>> > On Fedora 16, `nc -u -l <port number>` works fine.
>> 
>> Thanks for checking that.
>> 
>> If the information I found is correct, Fedora uses OpenBSD's nc
>> codebase.  The two netcat packages I tested on a Gentoo system differ in
>> requiring the -p switch for the port specification.
>
> So say exactly that in the doc: that the *BSD's version of nc doesn't
> need the port number specified with '-p' and you're covered.

OK, I tried that in the attached patch.
I'm not sure if every exeption needs to/should be documented, though.

Dirk

>From 3cdeac3e814471053129145c5fa8391acb365fd8 Mon Sep 17 00:00:00 2001
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Date: Sat, 28 Jul 2012 12:32:49 +0200
Subject: [PATCH] netconsole.txt: non-BSD versions of nc(1) require '-p'
 switch

Gentoo for example uses non-BSD versions of nc(1) which require
the '-p' switch to specify the listening port.
---
 Documentation/networking/netconsole.txt |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Documentation/networking/netconsole.txt b/Documentation/networking/netconsole.txt
index 8d02207..9a362f8 100644
--- a/Documentation/networking/netconsole.txt
+++ b/Documentation/networking/netconsole.txt
@@ -52,7 +52,8 @@ initialized and attempts to bring up the supplied dev at the supplied
 address.
 
 The remote host can run either 'netcat -u -l -p <port>',
-'nc -l -u <port>' or syslogd.
+'nc -l -u <port>' (BSD version of nc(1) e.g. Fedora),
+'nc -l -u -p <port>' or syslogd.
 
 Dynamic reconfiguration:
 ========================
-- 
1.7.8.6

