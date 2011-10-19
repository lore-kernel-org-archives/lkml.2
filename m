Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1JSMtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 08:49:31 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:57693 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab1JSMt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 08:49:29 -0400
Message-ID: <1319028563.8416.1.camel@edumazet-laptop>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nico Schottelius <nico-linux-20111017@schottelius.org>
Cc: Arend van Spriel <arend@broadcom.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date: Wed, 19 Oct 2011 14:49:23 +0200
In-Reply-To: <20111019123602.GA11883@schottelius.org>
References: <20111019123602.GA11883@schottelius.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 19 octobre 2011 à 14:36 +0200, Nico Schottelius a écrit :
> Hello,
> 
> I've
> 
> Eric Dumazet [Tue, Oct 18, 2011 at 02:24:25PM +0200]:
> > Must be a mutex_unlock(some_mltex) missing somewhere.
> > 
> > Then later, a process holding RTNL is blocking on mutex_lock(some_mutex)
> > 
> > Try a "CONFIG_LOCKDEP=y" enabled build
> 
> Did so, attached is the dmesg output after 3x suspend.
> 
> It also seems this bug gets more / only triggered when I loose the
> connection to a wpa2-eap network that is defined like this:
> 
> network={
>    ssid="eth"
>   id_str="eth-802.2x"
>    key_mgmt=WPA-EAP
>    proto=WPA2
>    eap=TTLS
>    pairwise=CCMP TKIP
>    group=CCMP TKIP
>    phase2="auth=MSCHAPV2"
>    identity="MYNAME"
>    password="forgottoremoveit"
> }
> 
> Hope the dmesg output helps and we can remove the problem soon
> and making the mba finally almost completly usable :-)
> 

Sorry, no CONFIG_LOCKDEP in your config or dmesg. Maybe you sent a
previous dmesg/config file ?

Note that you have "CONFIG_LOCKDEP_SUPPORT=y", not "CONFIG_LOCKDEP=y"



