Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab0LGUue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 15:50:34 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46539 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab0LGUuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 15:50:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MUsB7IOvwgwRIzFKiq86tJjhv0XGiyJkJZS1qOTSJepZkoklKSvQtibeay6YvnU1vU
         7wX/HZax8+zBGOsGb2AiBKMHr9j1oqjIcB5oT6nJB3bG7GuPOELFImA7XsJ95bA0301M
         GcC8wI13mkP78G9aT8K7CFO/Lo4TRZ178pz2g=
Subject: Re: bugs/regressions: report in LKML or in bugzilla?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <201012071639.58884.Martin@lichtvoll.de>
References: <201012071639.58884.Martin@lichtvoll.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 17:12:01 +0100
Message-ID: <1291738321.2695.338.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 07 décembre 2010 à 16:39 +0100, Martin Steigerwald a écrit :

> A participant of a linux performance training I hold found a bug with 
> window scaling which did not receive any reply as well:
> 
> Bug 20312 -  System freeze with multiples of 32 in 
> /proc/sys/net/ipv4/tcp_adv_win_scale
> https://bugzilla.kernel.org/show_bug.cgi?id=20312
> 

User bug ?

Documentation/networking/ip-sysctl.txt

tcp_adv_win_scale - INTEGER
	Count buffering overhead as bytes/2^tcp_adv_win_scale 
	(if tcp_adv_win_scale > 0) or bytes-bytes/2^(-tcp_adv_win_scale),
	if it is <= 0.
	Default: 2

Given we use 32bit numbers, using values outside of [-31 ... 31] makes litle sense.

We could add sysctl range limit, but user should not mess with 
/proc/sys/net/ipv4/parameters unless he knows what he is doing ?

Almost all /proc/sys/net/ipv4/parameters dont have range limits and unexpected
results with insane values feeded.

An other way to freeze a machine being root is :

halt


