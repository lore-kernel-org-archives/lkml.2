Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184Ab1JaPDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 11:03:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933083Ab1JaPDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 11:03:22 -0400
Date: Mon, 31 Oct 2011 17:03:43 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111031160342.GB2225@redhat.com>
References: <20111029171554.GA16596@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111029171554.GA16596@nomi.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 07:15:54PM +0200, Tomáš Janoušek wrote:
> Is there anything I can do to track this down? Perhaps try some experimental
> uCode or something?

You may try debugging patches I posted a while ago:
http://marc.info/?l=linux-mm&m=131914560820378&w=2
http://marc.info/?l=linux-mm&m=131914560820293&w=2
http://marc.info/?l=linux-mm&m=131914560820317&w=2

With a bit of luck, kernel should panic and dump call-trace when
bad code start to write at memory addresses where is not suppose
to.

You have to compile kernel with CONFIG_DEBUG_PAGEALLOC and add
corrupt_dbg=1 to catch memory corruption. However that may not
work if you have small amount of memory.

Also would be good to enable other debug options:

CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1

CONFIG_DEBUG_SG=y

CONFIG_DEBUG_LIST=y

Stanislaw
