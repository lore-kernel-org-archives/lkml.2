Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2CLNer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:34:47 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:42339
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755527Ab2CLNeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 09:34:46 -0400
Date: Mon, 12 Mar 2012 14:34:41 +0100 (CET)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Adding Secure Deletion to UBIFS
In-Reply-To: <1331559053.12037.25.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1203121430020.29192@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>   <1330536308.3545.158.camel@sauron.fi.intel.com>   <alpine.DEB.2.00.1203011434220.2462@eristoteles.iwoars.net>  <1331278562.22872.18.camel@sauron.fi.intel.com> 
 <alpine.DEB.2.00.1203091959570.25737@eristoteles.iwoars.net> <1331559053.12037.25.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I think you can use them. But is it possible to kill these things from
> the data nodes themselves? We can always find it by looking up the index
> by the data node key, right?
>

Yep, thats exactly right. Originally it was just inside the data node;
I put it into the TNC as a optimization later during development. If I use
the last eight bytes from the data node's key, and I remove the position
from ubifs_branch, then there is no longer any change to the on-disk
format, so thats should be useful. Yeah, storing the same value twice
means also needing a consistency check. What can be done is that when the
value is loaded once after mounting, it is stored in in the z-node in
memory.
