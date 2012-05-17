Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761887Ab2EQX20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 19:28:26 -0400
Received: from solo.fdn.fr ([80.67.169.19]:46429 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760588Ab2EQX2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 19:28:24 -0400
Date: Fri, 18 May 2012 01:28:21 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "Dave, Tushar N" <tushar.n.dave@intel.com>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>, Dean Nelson <dnelson@redhat.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] e1000: Reset rx ring index on receive overrun
Message-ID: <20120517232821.GJ683@type.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"Dave, Tushar N" <tushar.n.dave@intel.com>,
	"Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"Allan, Bruce W" <bruce.w.allan@intel.com>,
	"Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
	"Skidmore, Donald C" <donald.c.skidmore@intel.com>,
	"Rose, Gregory V" <gregory.v.rose@intel.com>,
	"Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
	"Duyck, Alexander H" <alexander.h.duyck@intel.com>,
	"Ronciak, John" <john.ronciak@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jiri Pirko <jpirko@redhat.com>, Dean Nelson <dnelson@redhat.com>,
	"e1000-devel@lists.sourceforge.net" <e1000-devel@lists.sourceforge.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20120517230140.GZ683@type.famille.thibault.fr>
 <061C8A8601E8EE4CA8D8FD6990CEA891188439E0@ORSMSX102.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <061C8A8601E8EE4CA8D8FD6990CEA891188439E0@ORSMSX102.amr.corp.intel.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave, Tushar N, le Thu 17 May 2012 23:22:31 +0000, a écrit :
> I am interested in to see if you have actual test case and more importantly test data that shows that kernel and device indexes are not synchronized any more.

Well, it's not with an actual physical device, but with the kvm
emulation. Printing indexes from the clean_rx handler, I'm getting:

(status linux index/total size/device index)

status 7 2/256/19
status 7 3/256/19
...
status 7 18/256/19
status 7 19/256/19
status 7 20/256/19
status 7 21/256/19
...
since the status is still 7, linux continues on.

...
status 7 254/256/19
status 7 255/256/19
status 7 0/256/19
status 7 1/256/19
status 0 2/256/19

here it stops, and on next interrupts,

status 0 2/256/20

status 0 2/256/21
etc. and no progress is made any more, until

status 0 2/256/253
status 0 2/256/254

and it gets stuck there:

status 0 2/256/254
status 0 2/256/254
status 0 2/256/254

Samuel
