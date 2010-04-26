Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab0DZOp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:45:58 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53303 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0DZOp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:45:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jQg5oGKRdM82/cVqQMtUgLoON+wgyDpSddFuVHOOixHJD++7dOVWre8Ucur9CElKjA
         ZxsfjE9iagX1ktOTqksV4U25YpS5bhMR+lQgNKPL7xm2x255Z5l1uwaZTmqeZZ7ds3Fc
         Ue6FH0FEiQfvneUEdcoQVn4yKd/CB+YgEC9BQ=
MIME-Version: 1.0
In-Reply-To: <y2lb43bf5491004260149x23beb95dqc9e177d9a6ecc679@mail.gmail.com>
References: <l2nb43bf5491004231314i13503c67yeccfc54bc1cae850@mail.gmail.com>
	 <h2p9929d2391004231322r23528f32z8447a711a29e28ea@mail.gmail.com>
	 <20100423135816.23f5861f@nehalam>
	 <r2ob43bf5491004231403o64f8b88bsa9543d9910648d97@mail.gmail.com>
	 <20100423150207.7969c9f6@nehalam>
	 <y2lb43bf5491004260149x23beb95dqc9e177d9a6ecc679@mail.gmail.com>
Date: Mon, 26 Apr 2010 16:45:54 +0200
Message-ID: <p2nb43bf5491004260745m58ed54b4ue50c2bd3431c9941@mail.gmail.com>
Subject: Re: [PATCH] e100: expose broadcast_disabled as a module option
From: Erwan Velu <erwanaliasr1@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
       bruce.w.allan@intel.com, alexander.h.duyck@intel.com,
       peter.p.waskiewicz.jr@intel.com, john.ronciak@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/26 Erwan Velu <erwanaliasr1@gmail.com>:

After some research, here come my status :

> Does any one you could help me understanding what should be the good way to
> 1- enabled/disabled IFF_BROADCAST for a given interface

Looks like the current code isn't taking care of a possible changing
of IFF_BROADCAST. I can find some code in net/core/dev.c to handle
MULTICAST or PROMISC but nothing for BROADCAST.
do I have to implement one ?


> 2- populate this changes to the driver

Looks like I need then to add a .ndo_change_rx_flags function to
manage this changes.

Does someone confirm this is the way to go ?
