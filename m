Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176Ab2I3Jis (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 05:38:48 -0400
Received: from ozy.pierre-beck.de ([178.63.78.113]:50703 "EHLO
	ozy.pierre-beck.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2I3Jir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 05:38:47 -0400
X-Greylist: delayed 1000 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Sep 2012 05:38:47 EDT
Message-ID: <5068130A.4050602@pierre-beck.de>
From: Pierre Beck <mail@pierre-beck.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 3.6-rc7 32-bit PAE miscalculates dirty page limits
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Original-Recipients: linux-kernel@vger.kernel.org
X-Original-Date: Sun, 30 Sep 2012 11:38:18 +0200
Date: Sun, 30 Sep 2012 11:38:45 +0200
X-Spam-Notice: Unscanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

there seems to be a bug in either ext4 or VM code triggered with 16 GB 
memory when compiled with 32-bit and PAE. dirty_background_ratio 
defaults to 10, dirty_ratio to 20. But in effect, dirty pages are 
strongly limited (zero or negative?). I observed extreme I/O wait states 
and slow disk access. A quick cure was to set dirty_bytes and 
dirty_background_bytes to sane values, overriding the ratios. An 
educated guess: the result of dirty_ratio calculation is stored as an 
unsigned 32-bit integer and overflows?

Greetings,

Pierre Beck
