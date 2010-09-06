Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab0IFOSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:18:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44725 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab0IFOSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WIGhw3MY11N6jVVPqPV/GY3BM+YcR+jwICL1XG1DSeZrhNel6q2fwjqQux+2Qm7vWC
         5d6s1SUviql2WOpwEvOHQ6n8Hxod7FVDWztRuSrhXNjhiOWz5bZ0v6vg4BKF8j8IHXV5
         arGSEiRUAkR8hb7N2ILUj3BLLPFk24J2PHpms=
Date: Mon, 6 Sep 2010 18:18:13 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 13/14] mm: mempolicy: Check return code of check_range
Message-ID: <20100906141813.GB9632@albatros>
References: <1283711588-7628-1-git-send-email-segooon@gmail.com>
 <20100906093610.C8B5.A69D9226@jp.fujitsu.com>
 <alpine.DEB.2.00.1009060201000.10552@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1009060201000.10552@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 02:02 -0700, David Rientjes wrote:
> On Mon, 6 Sep 2010, KOSAKI Motohiro wrote:
> 
> > > From: Vasiliy Kulikov <segooon@gmail.com>
> > > 
> > > Function check_range may return ERR_PTR(...). Check for it.
> > 
> > When happen this issue?
> > 
> > afaik, check_range return error when following condition.
> >  1) mm->mmap->vm_start argument is incorrect
> >  2) don't have neigher MPOL_MF_STATS, MPOL_MF_MOVE and MPOL_MF_MOVE_ALL
> > 
> > I think both case is not happen in real. Am I overlooking anything?
> > 
> 
> There's no reason not to check the return value of a function when the 
> implementation of either could change at any time.  migrate_to_node() is 
> certainly not in any fastpath where we can't sacrifice a branch for more 
> robust code.

Agreed, if you know that the caller must check input data and must not
check return code, it's better to make this function return void.

-- 
Vasiliy
