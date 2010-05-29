Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0E2COK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 22:14:10 -0400
Received: from bosmailout08.eigbox.net ([66.96.189.8]:51472 "EHLO
	bosmailout08.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab0E2COI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 22:14:08 -0400
X-Greylist: delayed 1925 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 May 2010 22:14:08 EDT
X-EN-OrigOutIP: 10.20.18.3
X-EN-IMPSID: PDhx1e00503yW7601DhxDn
Message-ID: <4C0070D8.8060500@jaysonking.com>
Date: Fri, 28 May 2010 20:41:44 -0500
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: tytso@mit.edu
CC: "Jayson R. King" <dev@jaysonking.com>, Stable team <stable@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Dave Chinner <david@fromorbit.com>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
Subject: Re: [PATCH 2.6.27.y 1/3] ext4: Use our own write_cache_pages()
References: <4C001888.8020006@jaysonking.com> <4C0018E1.5060007@jaysonking.com> <20100529004913.GL26177@thunk.org>
In-Reply-To: <20100529004913.GL26177@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 68.93.139.172
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2010 07:49 PM, tytso@mit.edu wrote:
> This doesn't fix a bug; it's to make it easy for Dave Chinner to make
> some changes to fix XFS's performance and to undo some ext4-specific
> changes to write_cache_pages().  I'm not sure there's a good reason to
> backport this to 2.6.27.y....

The difference is that, 2.6.27's write_cache_pages() in page-writeback.c 
still updates wbc->nr_to_write, since the patch which changed that 
behavior was dropped from .27-rc2 due to the XFS regression it causes on 
mainline. ext4 appears to want the behavior of write_cache_pages which 
does not update wbc->nr_to_write. This write_cache_pages_da() does what 
ext4 wants, without introducing the XFS regression. So I believe it is 
needed.

Did I mis-judge?

Rgds,

Jayson
