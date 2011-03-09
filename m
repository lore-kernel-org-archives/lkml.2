Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1CIVyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:54:32 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:44334 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752367Ab1CIVy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:54:29 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: vhWv2.sVM1nHMbuoykM4Z2IDzik82.CZoBTmmPhDQjX9efe
 TK_ek6phCazT0Ju_rfSudcdaBuc4spAJYAny9gE5b7zhcSQdwOp9eHujm4Xe
 gAGL0Oak2lr3ntOj3k_QaB_1YeZkuIwaiab6BdXfSyazPfZlItsAs_zWO7ax
 IO6nTW3o3heinAHzLzpq0AxP6JHOZiRxyRsZdtkZhuW7vSFI8BryfQH36Q42
 18vkAH2kqKNk-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 9 Mar 2011 15:54:24 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: David Rientjes <rientjes@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nick Piggin <npiggin@kernel.dk>, Dave Chinner <dchinner@redhat.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Bob Copeland <me@bobcopeland.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        linux-wireless@vger.kernel.org
Subject: Re: <IRQ> [<ffffffff810c9204>] ?
 __alloc_pages_nodemask+0x622/0x696
In-Reply-To: <4D77EEB4.9090404@gmail.com>
Message-ID: <alpine.DEB.2.00.1103091549020.16989@router.home>
References: <AANLkTikaLb_xan2ePfo9JCZ1w7RZ76wF8NUT2tYr0ZD=@mail.gmail.com> <alpine.DEB.2.00.1103051847100.8779@chino.kir.corp.google.com> <4D770178.9070908@gmail.com> <alpine.DEB.2.00.1103091254540.13353@chino.kir.corp.google.com>
 <4D77EEB4.9090404@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more things from the syslog that may be of relevance. System went
through multiple suspend and resume cycles.

Before the failure we have a wlan authentication and the ATH driver throws a fit.

[ 7339.673270] ll header: ff:ff:ff:ff:ff:ff:00:90:fb:1c:4f:5c:08:00
[ 7340.076865] FIREWALL:INPUT IN=wlan0 OUT= MAC=00:19:e3:06:2c:16:00:90:fb:1c:4f:5c:08:00 SRC=192.168.5.1
DST=192.168.5.11 LEN=48 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=ICMP TYPE=8 CODE=0 ID=251 SEQ=0
[ 7416.743752] cfg80211: Calling CRDA to update world regulatory domain
[ 7419.292521] wlan0: authenticate with 00:21:55:b4:20:20 (try 1)
[ 7419.312690] wlan0: authenticated
[ 7419.318325] wlan0: associate with 00:21:55:b4:20:20 (try 1)
[ 7419.322764] wlan0: RX AssocResp from 00:21:55:b4:20:20 (capab=0x401 status=0 aid=218)
[ 7419.322770] wlan0: associated
[ 7427.161366] ath: Failed to stop TX DMA in 100 msec after killing last frame
[ 7427.161432] ath: Failed to stop TX DMA!
[ 7434.492398] ath: Failed to stop TX DMA in 100 msec after killing last frame
[ 7434.492462] ath: Failed to stop TX DMA!
[ 7603.339047]
=============================================================================
[ 7603.339053] BUG radix_tree_node: Padding overwritten. 0xffff88000008fe00-0xffff88000008fe32
[ 7603.339055]
-----------------------------------------------------------------------------
[ 7603.339056]


Could the ath driver corrupt memory if the TX DMA cannot be stopped?

Maybe fix the driver first?


