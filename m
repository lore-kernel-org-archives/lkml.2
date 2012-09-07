Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577Ab2IGMPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:15:47 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:11318 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2IGMPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:15:42 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=8ONblgMZNqhox582m6utkhXCibPfFpyVE6TCxCFu/jf1fTItE6sfEDYTPBuc
	fb6n4GOJz599GF0OfLO8zsTFwfL7JoO0Zvpn4ILAZfIDsxRqxfU07wNS4
	+Nid4A6HHZmRrlJoA2iex4vC9TAOH38KXmFZk8HvTVeAeTnnniLx5Q=;
X-Spam-Processed: mail.digidescorp.com, Fri, 07 Sep 2012 07:15:40 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1597828599=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1347020137.2223.13.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
From: "Steven J. Magnani" <steve@digidescorp.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        bfields@fieldses.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Fri, 07 Sep 2012 07:15:37 -0500
In-Reply-To: <CAKYAXd-QtSYy4SQErVTXrxcv=YhFzhOm3PKpj=HoZKmpAG7vGQ@mail.gmail.com>
References: <1346774264-8031-1-git-send-email-linkinjeon@gmail.com>
	 <20120904161747.GJ23464@ZenIV.linux.org.uk>
	 <CAKYAXd_wTxqbC-UxYimCkZtvSddx=f3FG0hoiEY_doMjoxkKog@mail.gmail.com>
	 <87harc34d9.fsf@devron.myhome.or.jp>
	 <CAKYAXd-8aztDe1QiFT=NSQX8J+h_FM+cAWwo+Q+fUQHpNGTctw@mail.gmail.com>
	 <87y5knz6l5.fsf@devron.myhome.or.jp>
	 <CAKYAXd_mxq26bhRYd-YM9OBjYMO12TD4wHxm6PqHBLjgGFHaZg@mail.gmail.com>
	 <CAKYAXd-QtSYy4SQErVTXrxcv=YhFzhOm3PKpj=HoZKmpAG7vGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 16:01 +0900, Namjae Jeon wrote: 
> Hi. OGAWA.
> 
> I checked read-only option for export on FAT.
> I think that there are 3 approaches as mentioned below.
> 
> 1. As per the current scenario – user already has the option of
> setting ‘ro’ in /etc/exports – so that can also be used to make it
> read-only.
> 	
> 2. Forcefully set to “read-only” while executing FAT export operation.
> -> As you know, we can set read-only(ro) export in /etc/exports.
> If we set read-only export regardless of /etc/exports, This is "HACK"
> and it will work regardless of user setting.
> 
> 3. When FAT is mounted with -onfs option,-> Make it ‘ro’ at the mount
> time itself.
> -> It is simple to implement, but VFAT of NFS Server will be set to
> read-only as well as NFS client.

I argue against (2) and (3). A change that drops any possibility of
NFS-mounting VFAT filesystems read-write will break my use case. Where
ESTALE is an issue, there are client-side solutions, either mounting
with lookupcache=none (which admittedly has a severe performance impact)
or the VFS patches to handle ESTALE that are working their way towards
mainline. I recognize that not everyone can take advantage of
client-side features, but options (2) and (3) make life worse for those
who can.
------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>


