Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381Ab0EYRZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 13:25:31 -0400
Received: from bosmailout11.eigbox.net ([66.96.190.11]:46558 "EHLO
	bosmailout11.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458Ab0EYRZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 13:25:29 -0400
X-Greylist: delayed 1895 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2010 13:25:29 EDT
X-EN-OrigOutIP: 10.20.18.5
X-EN-IMPSID: Mstn1e00206Zqne01stndJ
Message-ID: <4BFC0070.9010408@jaysonking.com>
Date: Tue, 25 May 2010 11:53:04 -0500
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Thunderbird/3.0.3
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-fsdevel@vger.kernel.org,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>, "Jayson R. King" <dev@jaysonking.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [10/24] vfs: Add no_nrwrite_index_update writeback control flag
References: <20100524223544.GA13721@kroah.com> <20100524223016.208581966@clark.site> <20100525111208.GA8779@infradead.org>
In-Reply-To: <20100525111208.GA8779@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 68.93.139.172
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2010 06:12 AM, Christoph Hellwig wrote:
> On Mon, May 24, 2010 at 03:28:06PM -0700, Greg KH wrote:
>> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> NACK.  This has been shown to cause severe writeback regression for
> other filesystems and is beeing reverted in mianline.

It can't be reverted directly (you'll get a build failure) since the
next ext4 patch in this -stable series depends on it.

There's a commit from Ted Ts'o in the ext4 git, "ext4: Use our own
write_cache_pages()", which removes the dependency, but that patch is
not yet in mainline so isn't a -stable candidate. When/if that patch
hits mainline, it can be added to -stable and this patch dropped/reverted.

Jayson
