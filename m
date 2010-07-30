Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209Ab0G3R0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:26:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37895 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759196Ab0G3R0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:26:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Zq5sHQn9JrnXZv0ntyJciQr+7D4caJworPQiL13HGIPTN9IZP5BHoIxRP5Ngu43Bau
         byuLDZDvH9ykcScENAUvWAtOajADTpiMu3TXH8dv00d5cHKcpaPFqqiasMuZZNBytVuD
         oph/7H4p2vWISliiEEAsK6XP0GVIxWjnBSHtI=
MIME-Version: 1.0
Date: Fri, 30 Jul 2010 11:26:31 -0600
Message-ID: <AANLkTi=J=LS8+RJp_0yvEm8fs6WLTRvvyoKhHjcnnTmk@mail.gmail.com>
Subject: Asymtopic Behavior in IP Hashing Performance All Kernels 2.6.28.10 
	and above
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the cwgen.ko packet generator set to the following range of
settings on a Compaw Presario 2200 laptop, I see the following
performance behavior on system throughput:

CURRENT
http://open-cworthy-linux-packet-generator.googlecode.com/files/cwgen-07-29-2010.tar.gz

REPOSITORIES
http://code.google.com/p/open-cworthy-linux-packet-generator/
http://sourceforge.net/projects/cworthypktgen/

Interface: lo
Mode: continuous
IP Mode: Random Source/IP/Ports
pktsize: 1500
Interpacket Gap Time:  0 ns

runs at 89 megabytes per second throughput

Interface: lo
Mode: Continuous
IP Mode: Static IP/Static Ports
Source: 127.0.0.1
Dest 127.0.0.2
Range: 16 addresses
pktsize: 1500
Interpacket Gap Time:  0 ns

runs at 217 megabytes per second throughput

There is a significant performance drop (to roughly 1/3) when large
numbers of random IP addresses are routed through the IP stack.
Utilization does not seem to vary much, but the routing throughput
drops drastically.

Jeff Merkey
