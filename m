Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab2CEO5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:57:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932300Ab2CEO5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:57:33 -0500
Date: Mon, 5 Mar 2012 15:57:01 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
Cc: wwguy <wey-yi.w.guy@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>, security@kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20120305145700.GA17800@redhat.com>
References: <20111111150105.GA25437@nomi.cz>
 <20111114140714.GD2513@redhat.com>
 <20111119181106.GA5515@nomi.cz>
 <1321755233.22510.1.camel@wwguy-ubuntu>
 <20111120032016.GA14520@nomi.cz>
 <1321763314.22510.4.camel@wwguy-ubuntu>
 <20111120204007.GA7273@nomi.cz>
 <20120210180929.GA17733@nomi.cz>
 <20120214092020.GB12905@redhat.com>
 <20120305140130.GA15186@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120305140130.GA15186@nomi.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 03:01:30PM +0100, Tomáš Janoušek wrote:
> > That make sense! Your "CPU instructions break things" theory sounds crazy,
> > but I think it's logical. WPA enterprise differ from WPA-PSA (pre shared
> > key) that the key changed periodically, SSL is used when keys are changed
> > (via wpa_supplicant). So looks like 32-bit openssl generate object code
> > that trigger bug on CPU, which crash other processes.
> 
> It seems that someone beat me to it. Since Linus fixed the FPU leaks in
> 3.3-rc4, I haven't experienced the problem. And I was this close! :-)

Yeh, that was really nasty bug. 

> Anyway, thanks for assistance and sorry for being so slow to respond.

No problem. Can you remind me, is this reproducible on 64-bit kernel
with 32-bit user space? I'm asking because I would like to know if we
need to  backport those fixes to our kernel. We do not enable
CONFIG_CRYPTO_AES_NI_INTEL on 32 bit kernel, only on 64 bit, but if this
problem happen with 32-bit user land with 64 bit kernel, we will need to
do backport.

Thanks
Stanislaw
