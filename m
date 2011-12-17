Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab1LQSEg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 13:04:36 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58679 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1LQSEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 13:04:33 -0500
Message-ID: <1324145067.4496.44.camel@lappy>
Subject: Re: [PATCH] 9p: Don't use ATTR_* values from fs.h in userspace
 facing  structs
From: Sasha Levin <levinsasha928@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
        davem@davemloft.net, aneesh.kumar@linux.vnet.ibm.com,
        jvrao@linux.vnet.ibm.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 17 Dec 2011 20:04:27 +0200
In-Reply-To: <20111217174725.GW2203@ZenIV.linux.org.uk>
References: <1324134422-16642-1-git-send-email-levinsasha928@gmail.com>
	 <20111217174725.GW2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-17 at 17:47 +0000, Al Viro wrote:
> Look, that's the problem with exposing this stuff to protocol; you don't
> get clear semantics and are you seriously asking for trouble on kernel
> changes.  Suppose tomorrow we get rid of e.g. ATTR_KILL_PRIV; what are you
> guys going to do?  Hope that no 9p server has behaviour dependent on that
> flag being set or cleared?
> 
> Don't turn the kernel internals into a part of ABI.  And blind bulk remapping
> of constants is exactly that... 

I went with Aneesh's suggestion and did something similar to something
9p already has done before.

This is probably a good opportunity to open it up for discussion, since
I currently have a block of code containing those ATTR_* defines
copy-pasted from linux/fs.h in my userspace code, and thats obviously a
serious wtf.

-- 

Sasha.

