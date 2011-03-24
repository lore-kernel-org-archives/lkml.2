Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057Ab1CXPhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:37:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60967 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab1CXPhb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:37:31 -0400
MIME-Version: 1.0
Message-ID: <8e934520-3ed7-470a-ada4-80ae2b41ae60@default>
Date: Thu, 24 Mar 2011 08:37:03 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: RE: linux-next: manual merge of the cleancache tree with Linus' tree
References: <20110324135524.261bb5a9.sfr@canb.auug.org.au>
 <20110323205615.6984f974.akpm@linux-foundation.org>
 <AANLkTikagME334Y6PH4P_Nybf_h=fov5CiNBAY7KxYyN@mail.gmail.com
 AANLkTimQQHHN6pS17R_mGmF+oG33D3Apb6E_pNvsLHwv@mail.gmail.com>
In-Reply-To: <AANLkTimQQHHN6pS17R_mGmF+oG33D3Apb6E_pNvsLHwv@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D8B652F.0049,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> Is this stuff going to be merged into Linus' tree this time round?

Hi Stephen --

Still TBD.  Some discussion has occurred offlist.

> >> I did the cleancache_flush_page() before the
> delete_from_page_cache(),
> >> in case the delete_from_page_cache() freed the page.  I didn't
> actually
> >> check whether that makes sense though.
> >
> > I am not sure cleancache's put and flush semantic.
> > If I understand rightly with old __remove_from_page_cache's comment,
> > maybe cleancache_flush_page is to invalidate the page

Hi Minchan and Stephen --

I will take a close look at this and possibly ask Chris Mason to
take a look as well (since these hooks were placed by Chris in 2008
and this is the first significant change around the hooks since then).

I think as long as the page is still locked and the mapping
remains valid, the ordering may not matter, but will confirm
and test.
 
> Dan, one more thing.
> 
> #define cleancache_fs_enabled_mapping(_mapping) \
>         (mapping->host->i_sb->cleancache_poolid >= 0)
> 
> One is "_mapping", another is  "mapping"

Oops!  Nice catch, Minchan!  Will fix (using C, per
Andrew's reply).

Thanks,
Dan

