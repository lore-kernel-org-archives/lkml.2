Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab2KMVFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:05:01 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab2KMVFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:05:00 -0500
Date: Tue, 13 Nov 2012 13:04:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dan Magenheimer <dan.magenheimer@oracle.com>
cc: KY Srinivasan <kys@microsoft.com>, Konrad Wilk <konrad.wilk@oracle.com>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, hannes@cmpxchg.org,
        yinghan@google.com
Subject: RE: [PATCH 1/1] mm: Export a function to read vm_committed_as
In-Reply-To: <d85b47d7-00d0-4ebd-afdf-1e69747d0a91@default>
Message-ID: <alpine.DEB.2.00.1211131255310.5164@chino.kir.corp.google.com>
References: <1352600728-17766-1-git-send-email-kys@microsoft.com> <alpine.DEB.2.00.1211101830250.18494@chino.kir.corp.google.com> <426367E2313C2449837CD2DE46E7EAF930E35B45@SN2PRD0310MB382.namprd03.prod.outlook.com> <alpine.DEB.2.00.1211121349130.23347@chino.kir.corp.google.com>
 <426367E2313C2449837CD2DE46E7EAF930E39FBC@SN2PRD0310MB382.namprd03.prod.outlook.com> <c04bb062-bbce-4980-b2b3-fbbb18e64b66@default> <alpine.DEB.2.00.1211121547450.3841@chino.kir.corp.google.com> <426367E2313C2449837CD2DE46E7EAF930E3E0B5@BL2PRD0310MB375.namprd03.prod.outlook.com>
 <d85b47d7-00d0-4ebd-afdf-1e69747d0a91@default>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012, Dan Magenheimer wrote:

> KY is simply asking that the data item be exported so that he can
> use it from a new module.  No change to the Xen selfballoon driver
> is necessary right now and requiring one only gets in the way of the
> patch.  At some future time, the Xen selfballoon driver can, at its
> leisure, switch to use the new exported function but need not
> unless/until it is capable of being loaded as a module.
> 

That's obvious.

> And, IIUC, you are asking that KY's proposed new function include a
> comment about how it is used by Xen?  How many kernel globals/functions
> document at their point of declaration the intent of all the in-kernel
> users that use/call them?  That seems a bit unreasonable.  There is a
> very long explanatory comment at the beginning of the Xen
> selfballoon driver code already.
> 

Sorry, I don't think it's unreasonable at all: if you're going to be using 
a symbol which was always assumed to be internal to the VM for other 
purposes and then that usage becomes convoluted with additional usage like 
in KY's patch, then no VM hacker will ever know what a change to that 
symbol means outside of the VM.  There's been a lot of confusion about why 
this heuristic is needed outside the VM and whether the symbol is actually 
the correct choice, so verbosity as to the intent of what it is to 
represent is helpful for a maintainable kernel.

Presumably xen is hijacking that symbol for a similar purpose to KY's 
purpose, but perhaps I was too optimistic that others would help to 
solidify the semantics in which it is being used and describe it 
concisely.
