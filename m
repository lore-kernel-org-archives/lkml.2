Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab2HVEH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:07:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49107 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab2HVEHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 00:07:51 -0400
Message-ID: <50345B12.1050600@lwfinger.net>
Date: Tue, 21 Aug 2012 23:07:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        John W Linville <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Regression associated with commit c8628155ece3 - "tcp: reduce out_of_order
 memory use"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The commit entitled "tcp: reduce out_of_order memory use" turns out to cause 
problems with a number of USB drivers.

The first one called to my attention was for staging/r8712u. For this driver, 
there are problems with SSL communications as reported in 
https://bugzilla.redhat.com/show_bug.cgi?id=847525.

Other drivers including rtl8187, rtl8192cu and rt2800usb cannot connect to a 
WPA1- or WEP-encrypted AP, but work fine with WPA2. The rtl8192cu problem is 
reported in https://bugzilla.kernel.org/show_bug.cgi?id=46171.

I find it hard to understand why this patch should cause these effects; however, 
I have verified that a kernel generated from "git checkout e86b2919" works fine. 
This commit is immediately before the patch in question.

Note, this patch was applied during the merge between 3.3 and 3.4. The 
regression has been undiscovered for some time.

Any help on this problem will be appreciated.

Larry
