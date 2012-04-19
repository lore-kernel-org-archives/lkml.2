Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab2DST5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 15:57:40 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44727 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208Ab2DST5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 15:57:38 -0400
Subject: Re: [PULL REQUEST] : ima-appraisal patches
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Date: Thu, 19 Apr 2012 15:57:28 -0400
In-Reply-To: <20120418183938.GH6589@ZenIV.linux.org.uk>
References: <1334754302.2137.8.camel@falcor>
	 <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
	 <1334772473.2137.22.camel@falcor>
	 <20120418183938.GH6589@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1334865448.2429.35.camel@falcor>
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041919-7282-0000-0000-000008546104
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 19:39 +0100, Al Viro wrote:
> On Wed, Apr 18, 2012 at 02:07:52PM -0400, Mimi Zohar wrote:

> NAKed at least until you come up with formal proof that there's no other
> lock where fput() would be possible and ->i_mutex was not allowed.  

Has the discussion here moved from deferring the __fput() for the
mmap_sem/i_mutex lockdep side case, to taking the i_mutex in __fput() in
general?  Lockdep has not reported any problems, other than for the
mmap_sem/i_mutex scenario.

> This
> is not a way to go; that kind of kludges leads to locking code that is
> impossible to reason about.

Are you referring to defering the __fput() or taking the i_mutex in
__fput() in general?

The i_mutex is currently used to protect file data and metadata (eg.
chown, chmod, xattrs).  After the last file data change, the file
metadata needs to be updated to reflect the file data changes.  As
i_mutex is used for protecting both the file data and file metadata, why
would taking the i_mutex in __fput() be kludgie.

I'd really appreciate any help, suggestions.

thanks,

Mimi

