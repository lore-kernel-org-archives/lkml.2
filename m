Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2CLN2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:28:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:61773 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377Ab2CLN2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 09:28:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127787351"
Message-ID: <1331559053.12037.25.camel@sauron.fi.intel.com>
Subject: Re: [patch] Adding Secure Deletion to UBIFS
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Mar 2012 15:30:53 +0200
In-Reply-To: <alpine.DEB.2.00.1203091959570.25737@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
	  <1330536308.3545.158.camel@sauron.fi.intel.com>
	  <alpine.DEB.2.00.1203011434220.2462@eristoteles.iwoars.net>
	 <1331278562.22872.18.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203091959570.25737@eristoteles.iwoars.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 20:29 +0100, Joel Reardon wrote:
> To me, being able to set secure erase or not as a partition level setting
> makes alot of sense. The OS partition does not need it, but the user file data
> partition will have it, and UBI makes sense that wear levelling is done
> among all the partitions properly. Then taint status for files'
> sensitivity doesn't need to be maintained. The deployer simply chooses for
> this part of the FS, do they want secure deletion over the data or not,
> one time at the beginning. (Compare this to the decision on whether or
> not to encrypt their entire partition or later encrypting each file they
> make.)

Well, it makes sense. I do not insist on having a separate interface for
secure deletion. But duplication of the same information in the B-tree
slots and the data nodes the slots point to does not make much sense to
me.

I mostly look at this from the maintainability and upstreamability POW
and I see that despite on the clever ideas the changes broke backward
compatibility, patches are big and intrusive. From my point of view -
contributors come and go but I keep maintaining this beast :-)

> I'll remove the change to tree branch, and repost correctly the
> version change where only data node is effected.

But please, keep in mind my motivations and ensure that what I suggest
makes sense from your POW!

>  Btw, when I was
> developing it I used the last 8 bytes from the key as the key position,
> because the key was 16 bytes but only 8 were used. Could you comment on
> the last 8 bytes of ubifs keys?

I think you can use them. But is it possible to kill these things from
the data nodes themselves? We can always find it by looking up the index
by the data node key, right?

-- 
Best Regards,
Artem Bityutskiy

