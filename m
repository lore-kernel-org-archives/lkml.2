Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab0GTTKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 15:10:47 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:56351 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab0GTTKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 15:10:46 -0400
Subject: Re: [PATCH 2/8] v3 Add new phys_index properties
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, greg@kroah.com
In-Reply-To: <4C45A3AB.6090407@austin.ibm.com>
References: <4C451BF5.50304@austin.ibm.com>
	 <4C451D92.6020406@austin.ibm.com>  <4C45A3AB.6090407@austin.ibm.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 20 Jul 2010 12:10:04 -0700
Message-ID: <1279653004.9207.296.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-20 at 08:24 -0500, Nathan Fontenot wrote:
> Update the 'phys_index' properties of a memory block to include a
> 'start_phys_index' which is the same as the current 'phys_index' property.
> This also adds an 'end_phys_index' property to indicate the id of the
> last section in th memory block.
> 
> Patch updated to keep the name of the phys_index property instead of
> renaming it to start_phys_index.

KAME is right on this.  We should keep the old one if at all possible.  

The only other thing we might want to do is move 'phys_index' to
'start_phys_index', and make a new 'phys_index' that does a WARN_ONCE(),
gives a deprecated warning, then calls the new 'start_phys_index' code.

So, basically make the new, more clear name, but keep the old one for a
while and deprecate it.  Maybe we could get away with removing it in ten
years. :)

-- Dave

