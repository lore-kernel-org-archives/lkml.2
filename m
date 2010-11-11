Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab0KKLQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:16:11 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55716 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab0KKLQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:16:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:reply-to:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=exyxl184WfBk3M6NIItmF1YH/CZUiPPWTT7BPJj2k+HjQmb2uGdpJg+uFUPPXPBhtN
         chfLwd1R6nVVMiW4TFYULsmXMHNQKiBXBcyXxehzeyPN9HWiu4lX5az6FavgQOZikety
         i+mxCriDTl7lWvNtfJAESma2vo/ZwTvn2X5Bg=
From: Florian Fainelli <florian@openwrt.org>
Reply-To: Florian Fainelli <florian@openwrt.org>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: Forked android kernel development from linux kernel mainline
Date: Thu, 11 Nov 2010 12:18:14 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Anca Emanuel <anca.emanuel@gmail.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com> <20101107215908.GA21070@kroah.com> <adar5esn1gd.fsf@cisco.com>
In-Reply-To: <adar5esn1gd.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011111218.15668.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Roland,

Le Thursday 11 November 2010 01:33:38, Roland Dreier a écrit :
>  > Isn't the openwrt stuff just drivers and some arch specific code?
>  > Nothing that is core infrastructure, and nothing preventing them from
>  > submitting the drivers and arch code if they want to, right?
> 
> Actually openwrt has some core infrastructure for managing (ethernet)
> switches as extra-fancy multiport PHYs.  That means that all the drivers
> in openwrt for the typical 5-8 port switches in home routers don't
> really apply to mainline.

This is called "swconfig"  in OpenWrt and it works in two parts:

- a swconfig driver, which interfaces the getting and setting of switches 
attributes using netlink, therefore there is an user-space counter-part

- the switch drivers are implemented as phylib drivers with a phylib fixup 
callback to allow proper detection of these (you cannot alwasy simply read the 
standard PHY ID), the config_init callback will set correct defaults for the 
switch to be usable even without swconfig

The rationale behind swconfig comes from the fact that the Marvell DSA switch 
infrastructure is both too complex and too-specific to driver relatively 
simpler switches.

One could therefore just use the "phylib switch driver" without swconfig and 
have it working.
--
Florian
