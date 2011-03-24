Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1CXBxC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 21:53:02 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50760 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab1CXBxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 21:53:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [Q] PGPGIN underflow?
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20110324105307.1AF3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 24 Mar 2011 10:52:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Recently, vmstast show crazy big "bi" value even though the system has
no stress. Is this known issue?

Thanks.


% vmstat 1
procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 1  0      0 1133060 151336 479708    0    0     0     0   50   50  0  0 100  0  0
 1  0      0 1133060 151336 479708    0    0     0     0   35   30  0  0 100  0  0
 0  0      0 1133060 151336 479708    0    0     0     0   27   24  0  0 100  0  0
 0  0      0 1133060 151336 479708    0    0     0     0   29   26  0  0 100  0  0
 0  0      0 1133060 151336 479708    0    0     0     0   26   22  0  0 100  0  0
 0  0      0 1133060 151336 479708    0    0     0     0   27   24  0  0 100  0  0
 1  0      0 1133060 151336 479708    0    0     0     0   45   49  0  0 100  0  0
 0  0      0 1133060 151336 479708    0    0     0     0   62   54  1  0 99  0  0
 0  0      0 1133060 151336 479708    0    0     0     0   54   56  0  0 100  0  0
 0  0      0 1133060 151336 479708    0    0     0     0   28   24  0  1 99  0  0
 1  0      0 1133060 151336 479708    0    0     0     0   54   54  0  0 100  0  0
 0  0      0 1133060 151336 479708    0    0     0     0   42   38  0  1 100  0  0
 0  0      0 1133060 151336 479708    0    0     0     0   31   24  0  0 100  0  0
 0  0      0 1133060 151336 479708    0    0     0     0   33   24  0  0 100  0  0
 1  0      0 1133060 151336 479708    0    0     0     0   56   58  1  0 100  0  0
 0  0      0 1133060 151336 479708    0    0     0     0  157  225  1  0 98  0  0
 0  0      0 1133060 151336 479708    0    0     0     0   40   37  0  0 100  0  0
 0  0      0 1133060 151336 479708    0    0     0     0   51   47  0  0 100  0  0
 1  0      0 1133060 151336 479708    0    0     0     0   51   46  1  0 99  0  0
 0  0      0 1133060 151336 479708    0    0     0     0  296  418  2  0 97  0  0
 0  0      0 1133060 151336 479708    0    0     0     0  295  419  3  2 95  0  0
 0  0      0 1133060 151336 479708   16    0     0     0  313  449  3  1 96  0  0
 0  0      0 1132936 151336 479708    0    0 4294967293     0  331  448  5  1 95  0  0
 1  0      0 1132936 151336 479708    0    0     0     0  303  445  3  1 96  0  0
 0  0      0 1132936 151336 479708   16    0     0     0  308  433  3  1 96  0  0
 0  0      0 1132936 151336 479708    0    0     0     0  307  450  4  0 96  0  0
 1  0      0 1132936 151344 479704   96    0     0     0  255  222  6  1 93  0  0
 1  0      0 1132812 151344 479708    0    0 4294967293     0  397  310 11  1 88  0  0
 0  0      0 1132688 151344 479708    0    0 4294967293     0  410  365  9  1 90  0  0
 1  0      0 1132812 151344 479708    0    0     3     0   33   32  0  0 100  0  0
 0  0      0 1132812 151344 479708    0    0     0     0   31   23  0  0 100  0  0
 0  0      0 1132812 151344 479708    0    0     0     0   35   34  0  0 100  0  0

