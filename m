Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0JRLEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 07:04:12 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:40759 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab0JRLEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 07:04:10 -0400
X-Auth-Info: 9oDihe6ZgEYNUYH7n4a4Gob0gGIfZfJgqGJUkM4ypcM=
Message-ID: <4CBC29E6.3070601@grandegger.com>
Date: Mon, 18 Oct 2010 13:05:10 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, ML netdev <netdev@vger.kernel.org>,
        ML linux-kernel <linux-kernel@vger.kernel.org>,
        andrew.chih.howe.khor@intel.com, "Wang, Qi" <qi.wang@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Intel OTC <joel.clark@intel.com>
Subject: Re: [MeeGo-Dev] can: How to set bitrate
References: <000b01cb6eb3$1afcfd60$66f8800a@maildom.okisemi.com>
In-Reply-To: <000b01cb6eb3$1afcfd60$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2010 12:56 PM, Masayuki Ohtake wrote:
> I want to test our Socket CAN driver(for Topcliff) on Meego1.0.
> 
> For setting bitrate, I tried to install "iproute2". But the build failed.
> 
> ================================================
> [root@localhost iproute2-2.6.33]# make
> sh configure
> TC schedulers
>  ATM no
>  IPT using iptables
> make[1]: Entering directory `/root/iproute2-2.6.33/lib'
> 
> <omission>
> 
> ude  -o arpd arpd.c ../lib/libnetlink.a ../lib/libutil.a -ldb -lpthread
> arpd.c:19:20: error: db_185.h: No such file or directory
> arpd.c:42: error: expected '=', ',', ';', 'asm' or '__attribute__' before '*' token
> arpd.c: In function 'do_one_request':
> arpd.c:304: error: 'DBT' undeclared (first use in this function)
> arpd.c:304: error: (Each undeclared identifier is reported only once
> arpd.c:304: error: for each function it appears in.)
> arpd.c:304: error: expected ';' before 'dbkey'
> arpd.c:308: error: 'dbase' undeclared (first use in this function)
> arpd.c:338: error: 'dbkey' undeclared (first use in this function)
> arpd.c:341: error: 'dbdat' undeclared (first use in this function)
> arpd.c: In function 'get_arp_pkt':
> arpd.c:485: error: 'DBT' undeclared (first use in this function)
> arpd.c:485: error: expected ';' before 'dbkey'
> arpd.c:517: error: 'dbkey' undeclared (first use in this function)
> arpd.c:520: error: 'dbase' undeclared (first use in this function)
> arpd.c:520: error: 'dbdat' undeclared (first use in this function)
> arpd.c: In function 'main':
> arpd.c:670: error: 'dbase' undeclared (first use in this function)
> arpd.c:670: warning: implicit declaration of function 'dbopen'
> arpd.c:670: error: 'DB_HASH' undeclared (first use in this function)
> arpd.c:680: error: 'DBT' undeclared (first use in this function)
> arpd.c:680: error: expected ';' before 'dbkey'
> arpd.c:682: error: 'dbkey' undeclared (first use in this function)
> arpd.c:712: error: 'dbdat' undeclared (first use in this function)
> arpd.c:728: error: expected ';' before 'dbkey'
> arpd.c:730: error: 'R_NEXT' undeclared (first use in this function)
> make[1]: *** [arpd] Error 1
> make[1]: Leaving directory `/root/iproute2/misc'
> make: *** [all] Error 2
> [root@localhost iproute2]#
> ================================================

On my system I get:

~$ rpm -qf /usr/include/db_185.h
db4-devel-4.7.25-13.fc12.i686

Which means you need db4 devel to fully build iproute2.

> Do you know how to set bitrate on Meego?

ip from iproute2 is the right tool.

Wolfgang.

