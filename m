Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab1DZUqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:46:40 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:57754 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab1DZUqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:46:39 -0400
Subject: Re: [PATCH 3/3] flex_array: allow 0 length elements
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: steffen.klassert@secunet.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@tycho.nsa.gov, sds@tycho.nsa.gov
In-Reply-To: <20110426014543.1740.89115.stgit@paris.rdu.redhat.com>
References: <20110426014531.1740.24077.stgit@paris.rdu.redhat.com>
	 <20110426014543.1740.89115.stgit@paris.rdu.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 26 Apr 2011 13:46:20 -0700
Message-ID: <1303850780.9308.17380.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 21:45 -0400, Eric Paris wrote:
> allow elements of 0 length.  We already allow flex_arrays with 0
> elements, but
> this patch allow us to have elements that are 0 bytes long.
> 
> Based-on-patch-by: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Eric Paris <eparis@redhat.com> 

I'd like to see a bit of the history in the changelog.  kmalloc(0)
returns NULL, and we'd effectively like to do the same since flex_arrays
really are like a mini allocator.  The 0-sized elements come from
userspace and we *have* to handle them in the security code, etc...

The code looks good, though.

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

