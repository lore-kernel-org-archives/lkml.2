Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184Ab0CRJV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:21:26 -0400
Received: from borg.medozas.de ([188.40.89.202]:56428 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab0CRJVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:21:25 -0400
Date: Thu, 18 Mar 2010 10:21:21 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Michal Marek <mmarek@suse.cz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kconfig: report select on a depending option
Message-ID: <alpine.LSU.2.01.1003181015060.9334@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


With the following combination of Kconfig config options, I can select 
TEST_Z, which will select TEST_X, even if TEST_Y=n. It also allows for 
awkward situations like TEST_Y=M, TEST_X=y, TEST_Z=y, which would yield 
a link time error when X uses Y's symbols.
Is there a way to have such potential errors reported with kconfig?

config TEST_Y
	tristate "Y"

config TEST_X
	depends on Y
	tristate "X"

config TEST_Z
	select TEST_Y
	tristate "Z"

thanks,
Jan
