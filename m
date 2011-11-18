Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab1KRXjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:39:17 -0500
Received: from dee.erg.abdn.ac.uk ([139.133.204.82]:58738 "EHLO erg.abdn.ac.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751479Ab1KRXjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:39:16 -0500
X-Greylist: delayed 694 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Nov 2011 18:39:15 EST
Date: Fri, 18 Nov 2011 16:27:29 -0700
From: Gerrit Renker <gerrit@erg.abdn.ac.uk>
To: Jinxin Zheng <jinxinzheng@gmail.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: ipv4 udplite broken in >=linux-3.0 ?
Message-ID: <20111118232729.GA3902@gerrit.erg.abdn.ac.uk>
Mail-Followup-To: Gerrit Renker <gerrit@erg.abdn.ac.uk>,
	Jinxin Zheng <jinxinzheng@gmail.com>,
	Hagen Paul Pfeifer <hagen@jauu.net>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
References: <CABPbr_msepemFt4ezGVRk3QS0MU3F47MKimfV4Y+6jqvUrLFeA@mail.gmail.com>
 <20111118120430.GG3317@hell>
 <CABPbr_=fgB-AKK3H8ryccqA7SUO=ejZiWP7tEKYLh=qNG5r7CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPbr_=fgB-AKK3H8ryccqA7SUO=ejZiWP7tEKYLh=qNG5r7CQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-ERG-MailScanner: Found to be clean
X-ERG-MailScanner-From: gerrit@erg.abdn.ac.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jinxin, -
| On Fri, Nov 18, 2011 at 8:04 PM, Hagen Paul Pfeifer <hagen@jauu.net> wrote:
| > * Jinxin Zheng | 2011-11-18 12:09:25 [+0800]:
| >
| >>I don't know how to debug udplite. Can any one of you give me a tip on
| >>how to get more debug info, then I can do further test and provide
| >>with it?
| >
| > net-next works for me:
That is very likely the point. Between 2.6.39 and 3.0 UDP-Lite checksum coverage was
broken and got only recently fixed. The correct kernel version should have the 
commit shown below. Alternatively, you can check include/net/udplite.h, which
should mention "Slow-path" and "Fast-Path" computation. UDP-Litev6 still uses the
slow path, that is why it is not affected.
    

commit f36c23bb9f822904dacf83a329518d0a5fde7968
Author: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Date:   Mon Oct 17 19:07:30 2011 -0400

    udplite: fast-path computation of checksum coverage
    
    Commit 903ab86d195cca295379699299c5fc10beba31c7 of 1 March this year ("udp: Add
    lockless transmit path") introduced a new fast TX path that broke the checksum
    coverage computation of UDP-lite, which so far depended on up->len (only set
    if the socket is locked and 0 in the fast path).
    
    Fixed by providing both fast- and slow-path computation of checksum coverage.
    The latter can be removed when UDP(-lite)v6 also uses a lockless transmit path.
  
