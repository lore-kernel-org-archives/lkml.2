Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab0DPTyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 15:54:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55172 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab0DPTyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 15:54:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=YznAL44bp2DmrQ/aUNovhFkWj/ENS60yuiYVK1j8wShKdNodDTHicIz0T0wVvA/uSS
         KGICK9mZu+s5Ku4JSCNQyetLs8d25hhOhO9cdZAev+FqKPcgu2VD5Vr7hJvoRZiORdj7
         CnlZ15GIPFGUkchukgKM5Q+xSilP0w2Gjx7hQ=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 16 Apr 2010 12:53:52 -0700
Message-ID: <n2q43e72e891004161253wbb9afe61y539206f010e91a78@mail.gmail.com>
Subject: Power consumption on 802.11 / ASPM / device measurements
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, yanmin.zhang@intel.com, shaohua.li@intel.com,
       Sameer Nanda <snanda@google.com>,
       Jonathan May <Jonathan.May@atheros.com>,
       David Quan <David.Quan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been accumulating a few power consumption related documents on
the wireless wiki for a while now. One which I saw was missing was for
actual power consumption and review of new PCI-E features which should
be taken into consideration when debugging power consumption or
reviewing it. ASPM is something that I can say I found little to no
documentation for when looking into it so I've done a brain dump of
what I recall from it, the code review of it, and some e-mail
exchanges I've had with Jonathan May @ Atheros.

I've stashed together all the power consumption docs at:

http://wireless.kernel.org/en/users/Documentation/Power-consumption

You'll see there some ASPM docs now and some ath9k specific power
consumption metrics/ASPM details. Please review and enhance as you see
fit.

Yanmin, Shaohua, I see CONFIG_PCIEASPM still marked as experimental,
I'm curious if this is still really that experimental and if there are
plans for it go out of experimental. Also I am little puzzled with
some of the aspm.c code, I see we fill the pci device struct with
capability stuff via pcie_aspm_cap_init() but I also see ASPM
capability stuff exposed on kernels without CONFIG_PCIEASPM (albeit I
see it always disabled on my system at home), so are we filling the
capability elsewhere? I think there are some boxes without this kernel
config enabled and where ASPM capability info is exposed and does show
up as enabled, could be wrong.

Also curious -- how often are BIOSes buggy enough for ASPM to get
disabled by mistake on the modern devices? And for systems that have
no Bios (*cough* ChromeOS) how is this handled?

 Luis
