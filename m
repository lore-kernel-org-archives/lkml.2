Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1AFSov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:44:51 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61251 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1AFSou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:44:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eWofq67wcAvdNhaDfidAGfELBBEbiaWFf7qN+dENF9a3/FDCzb2jh+USC0H7en49Eq
         kfJ2wGYaV+/+ibuk8We5JFVZUFTabtlvl6LJneEsp6jIPnEbV4HaEU53mFN4XEPmS4On
         cHLqfw9K5Kcv04ZSFP83aymWG6vACHncpoiy0=
Message-ID: <4D260A96.4020400@gmail.com>
Date: Thu, 06 Jan 2011 19:31:50 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 00/17] pramfs: persistent and protected RAM filesystem
References: <4D25AEEE.1050401@gmail.com> <1294322613.2016.333.camel@laptop> <4D25ED22.3070900@gmail.com> <4D25F4CF.1030009@gmail.com> <987664A83D2D224EAE907B061CE93D530193FC6AA2@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D530193FC6AA2@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/01/2011 19:22, Luck, Tony ha scritto:
>> Errata corrige: maybe I used the wrong term, I meant "volatile" instead
>> of "temporary" information, i.e. I'd like to save this info to re-read
>> it later but I don't want to store it in flash, a simple log, run-time
>> information for debug like a flight-recorder or whatever you want.
> 
> I'm puzzled by the use of "a generic piece of memory" to store "persistent"
> things (Perhaps this is made clear in the 17 parts of the patch? I haven't
> read them yet).  On x86 f/w typically clears all of memory on reset ... so
> you only get persistence if you use kexec to get from the old kernel to
> the new one.
> 
> -Tony
> 

First of all, you can find a lot of information on the web site where
there is an overview and a page with implementation details, benchmark
and so on. With "a generic piece of memory" I mean a generic memory
device directly addressable. Usually this generic device is an NVRAM, so
we have a persistent store. If you haven't got this hw you can use other
devices or the classic RAM, in this case you have a fs persistent only
over reboot. The use of this fs is mainly for embedded systems, fw can
be configured to not clear *all* the memory. Pramfs is indeed supported
by U-Boot, you can see CONFIG_PRAM in the Das U-Boot manual. x86 in this
case can be a "strange" world for this fs, but however if the user wants
it can be used without problems because there aren't neither strict arch
or hw dependency.

Marco
