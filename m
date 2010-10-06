Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab0JFJL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:11:59 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:47498 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819Ab0JFJL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:11:57 -0400
X-Auth-Info: YOCLCdOKlVlLZtWoLFDQocOxDuZEnhdbpD0QCnmNi/M=
Message-ID: <4CAC3D94.9010408@grandegger.com>
Date: Wed, 06 Oct 2010 11:12:52 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: masa-korg@dsn.okisemi.com, andrew.chih.howe.khor@intel.com,
        sameo@linux.intel.com, margie.foster@intel.com, netdev@vger.kernel.org,
        yong.y.wang@intel.com, linux-kernel@vger.kernel.org,
        socketcan-core@lists.berlios.de, mkl@pengutronix.de, chripell@fsfe.org,
        morinaga526@dsn.okisemi.com, meego-dev@meego.com,
        kok.howg.ewe@intel.com, joel.clark@intel.com, qi.wang@intel.com
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35
References: <002e01cb6486$2ed72cc0$66f8800a@maildom.okisemi.com>	<20101005.114506.184852374.davem@davemloft.net>	<000b01cb6503$962bc7f0$66f8800a@maildom.okisemi.com> <20101005.200904.71120150.davem@davemloft.net>
In-Reply-To: <20101005.200904.71120150.davem@davemloft.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2010 05:09 AM, David Miller wrote:
> From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
> Date: Wed, 6 Oct 2010 12:07:15 +0900
> 
>> Does your mail mean, for accepting upstream, NAPI is essential for
>> CAN driver ?
> 
> It is up to the CAN maintainers :-)

Well, our SJA1000 reference driver does still not use NAPI. But NAPI is
for CAN especially useful to avoid the infamous *bus error irq
flooding*, which may hang low end systems if the interrupts are handled
in the IRQ context. Ohtake, if your system can handle well such CAN bus
error irq storms at 1MB/s, then NAPI is *not* a must to have. Anyway, as
you are at it, I also suggest to use NAPI right from the beginning.

Wolfgang.
