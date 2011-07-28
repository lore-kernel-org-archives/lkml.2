Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1G1OW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 10:22:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:1816 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab1G1OW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 10:22:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,282,1309762800"; 
   d="scan'208";a="33117617"
Subject: Re: [PATCH] [64/99] Revert "iwlagn: Support new 5000 microcode."
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, "gregkh@suse.de" <gregkh@suse.de>,
        "herton.krzesinski@canonical.com" <herton.krzesinski@canonical.com>,
        "gengor@gentoo.org" <gengor@gentoo.org>,
        "Fry, Donald H" <donald.h.fry@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "tim.bird@am.sony.com" <tim.bird@am.sony.com>
In-Reply-To: <20110728082425.GA2207@redhat.com>
References: <20110727247.325703029@firstfloor.org>
	 <20110727214903.75C262403FF@tassilo.jf.intel.com>
	 <20110728082425.GA2207@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 06:45:33 -0700
Message-ID: <1311860733.5579.152.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 01:24 -0700, Stanislaw Gruszka wrote:
> On Wed, Jul 27, 2011 at 02:49:03PM -0700, Andi Kleen wrote:
> > 2.6.35-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > This reverts commit 6f63415fc1b690cb50c2ad48ba6e9e6e88e271b4.
> > 
> > It turns out this is not what we want to have happen for the .32 and
> > .33-longterm kernels as it does not work properly at all.
> 
> Hmm, it does not work on .32 and .33 because they do not contain
> the commit (which 2.6.35 has):
> 
> commit dd7a2509b3a79b290730a9c6a784bf03fedabb9a
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Wed Apr 28 23:33:10 2010 -0700
> 
>     iwlagn: implement loading a new firmware file type
> 
> > This was reported by Gentoo, Arch, and Canonical developers as causing
> > problems for their users:
> > 	https://bugs.archlinux.org/task/24302
> This is a bug about 2.6.32.
> 
> > 	http://bugs.gentoo.org/show_bug.cgi?id=359445
> This looks like problem when only 8.83.5 (v5) firmware is available
> on the system, but kernel is old and support only v2 version. This
> should be solved by providing both old 8.24.2 (v2) and new 8.83.5 (v5)
> firmware blobs in one package.
> 
> > 	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/796336
> Also 2.6.32 case.
> 
> There could be reasons for this change, but I do not see them here.
> 
The -5 version of firmware has addition TLV information in the firmware
file which provide the firmware capabilities to the driver. it is
important feature starting from -5 version of firmware; and it require
driver to parsing the new file type.

just like Gruszka mention, please include 
commit dd7a2509b3a79b290730a9c6a784bf03fedabb9a


Thanks
 
Wey


