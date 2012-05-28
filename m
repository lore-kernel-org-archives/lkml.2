Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab2E1QLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 12:11:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33647 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab2E1QLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 12:11:21 -0400
Message-ID: <1338221539.4284.25.camel@lappy>
Subject: Wrong usage of hash in L2TP leading to NULL ptr derefs
From: Sasha Levin <levinsasha928@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        jchapman@katalix.com
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 28 May 2012 18:12:19 +0200
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Looking at net/l2tp/l2tp_ip{6}.c, l2tp uses UDP for communications, but
uses inet_hash and inet_unhash for hashing - which appears to be wrong
(and causes NULL ptr derefs during runtime).

Since I'm not too familiar with the protocol, I'm not sure if the right
fix would be to switch it to use the UDP hashing code, or to actually
initialize everything inet_hash() expects so the current hashing would
work properly.

Help appreciated!

Thanks,
Sasha

