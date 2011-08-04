Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab1HDGv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 02:51:26 -0400
Received: from fallback3.mail.ru ([94.100.176.58]:43379 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1HDGvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 02:51:20 -0400
Message-ID: <4E3A3F87.3050204@mail.ru>
Date: Thu, 04 Aug 2011 10:43:19 +0400
From: "MRU.Ilya" <utdilya@mail.ru>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: stable@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: BUG: pty.c  in linux 2.6.31-rc5+
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Synchronic's line disciplines(ppp_synctty, hdlc) can't work with pseudo 
terminals.

If frames send very fast from one side(master/slave) to other one,
frames merge in one (merge point "flip buffer") and the other side can 
read only one big frame.
But sync line discipline need one frame in one read.

For push one frame to ldisc I propose small patch, but this regression for
commit e043e42bdb66885b3ac10d27a01ccb9972e2b0a3.

I don't find any mutexes and other things forbidden in not user context,
in function flush_to_ldisc() , and I think this patch
is true and this function can called from any context. But I not sure.

Relative commit  86d23a057e718f73adc15e463c643d6e014a19cd.

