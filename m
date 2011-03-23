Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab1CWNku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:40:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63316 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab1CWNks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=V7ofFmjbsGadonI6ukvVgRCO3cd+LHJmX9WoO1/nb9x39Qps2mvJR8mfme+PPxcSbJ
         BmQT9dB9j+6XmExHr9uZuozI619Bnof8i59zC/Jv7sM+XebJw81JTY7vM28w30HPvXin
         IOs3orWYRGpa4x7kzLMNHHnB+LMdFoEpKu4IE=
Date: Wed, 23 Mar 2011 10:40:37 -0300
From: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 2/5] Revert "oom: give the dying task a higher priority"
Message-ID: <20110323134037.GP5212@uudg.org>
References: <20110315153801.3526.A69D9226@jp.fujitsu.com>
 <20110322194721.B05E.A69D9226@jp.fujitsu.com>
 <20110322200657.B064.A69D9226@jp.fujitsu.com>
 <20110323164229.6b647004.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110323164229.6b647004.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 04:42:29PM +0900, KAMEZAWA Hiroyuki wrote:
| On Tue, 22 Mar 2011 20:06:48 +0900 (JST)
| KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
| 
| > This reverts commit 93b43fa55088fe977503a156d1097cc2055449a2.
| > 
| > The commit dramatically improve oom killer logic when fork-bomb
| > occur. But, I've found it has nasty corner case. Now cpu cgroup
| > has strange default RT runtime. It's 0! That said, if a process
| > under cpu cgroup promote RT scheduling class, the process never
| > run at all.
| > 
| > Eventually, kernel may hang up when oom kill occur.
| > 
| > The author need to resubmit it as adding knob and disabled
| > by default if he really need this feature.
| > 
| > Cc: Luis Claudio R. Goncalves <lclaudio@uudg.org>
| > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
| 
| Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

The original patch was written to fix an issue observed in 2.6.24.7-rt.
As the logic sounded useful, I ported it to upstream. Anyway,I am trying
a few ideas to rework that patch. In the meantime, I'm pretty fine with
reverting the commit.

Acked-by: Luis Claudio R. Gonçalves <lgoncalv@uudg.org>

-- 
[ Luis Claudio R. Goncalves                    Bass - Gospel - RT ]
[ Fingerprint: 4FDD B8C4 3C59 34BD 8BE9  2696 7203 D980 A448 C8F8 ]

