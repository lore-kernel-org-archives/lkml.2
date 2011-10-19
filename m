Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1JSGJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 02:09:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5029 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1JSGJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 02:09:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=VrcZy5XPY3lpl88z5d/8QbSRK1z8ttFv7toTveVFTbwG7u8LRY3oibfnlJXl49n8x
	5oaH4NCAk53Ko4OTAHv5Q==
Date: Tue, 18 Oct 2011 23:09:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Norbert Preining <preining@logic.at>
cc: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>, ilw@linux.intel.com,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn is getting very shaky
In-Reply-To: <20111019060108.GA11588@gamma.logic.tuwien.ac.at>
Message-ID: <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com>
References: <20111019060108.GA11588@gamma.logic.tuwien.ac.at>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011, Norbert Preining wrote:

> Hi everyone
> 
> (please Cc),
> 
> I am currently running 3.1.0-rc10, and I am having a hard time with
> the wlan network here at the university.
> 
> For quite some time, like 10min, it is fine, then suddently the
> iwlagn driver gives up on me and connection is dropped.
> 
> In the log file I see:
> [  172.137011] iwlagn 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 0
> [  821.841016] iwlagn 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 6
> [ 1095.580735] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
> [ 1095.780076] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
> [ 1095.980101] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
> [ 1096.180117] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
> [ 1105.255464] wlan0: deauthenticating from 00:24:c4:ab:bd:ef by local choice (reason=2)
> [ 1105.255519] iwlagn 0000:06:00.0: Stopping AGG while state not ON or starting
> [ 1105.265581] cfg80211: Calling CRDA for country: JP
> [ 1105.271476] wlan0: authenticate with 00:24:c4:ab:bd:e0 (try 1)
> [ 1105.468105] wlan0: authenticate with 00:24:c4:ab:bd:e0 (try 2)
> [ 1105.668110] wlan0: authenticate with 00:24:c4:ab:bd:e0 (try 3)
> [ 1105.868090] wlan0: authentication with 00:24:c4:ab:bd:e0 timed out
> [ 1113.667890] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
> [ 1113.864116] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
> [ 1114.064095] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
> [ 1114.264109] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
> 
> Somewhere around 1100 the connection is gone and never comes back again.
> 
> I tried removing the driver module from the kernel and reinserting it,
> tried to turn on and off the hardware swithc (rfkill), all without
> no success, the wlan connection remains dead until I reboot.
> 
> I am not sure exactely when it started, I guess somewhere in the
> 3.1 cycle, before I was permanently working wiht wlan, now I always
> plug in the cable.
> 
> If there is any way to track down this, or any suggestions how I can
> debug it, please let me know.
> 
> Hardware: Sony VGN-Z11, Intel(R) WiFi Link 5100 AGN, REV=0x54
> L1 Enabled; Disabling L0S
> device EEPROM VER=0x11e, CALIB=0x4
> Device SKU: 0Xf0
> Tunable channels: 13 802.11bg, 24 802.11a channels
> loaded firmware version 8.83.5.1 build 33692 (EXP)
> 
> 
> On the other hand, the same laptop with the very same configuration 
> works very nicely in my flat's wlan, which is some dirt cheap Japanese
> only wlan router.
> 

There have been recent issues in 3.1-rc9 reported with iwlagn, see the 
thread at https://lkml.org/lkml/2011/10/15/107 even though you have 
different hardware.  Adding Wey-Yi Guy from Intel and the linux-wireless 
mailing list to the cc.
