Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab0LMM5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:57:25 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:54767 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384Ab0LMM5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:57:24 -0500
Date: Mon, 13 Dec 2010 18:27:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dan Carpenter <error27@gmail.com>, jeffm@suse.com,
        linux-kernel@vger.kernel.org, brian@xyzw.org
Subject: Re: delayacct: alignment changes break iotop
Message-ID: <20101213125709.GB14178@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101213113745.GE1620@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101213113745.GE1620@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dan Carpenter <error27@gmail.com> [2010-12-13 14:37:45]:

> Iotop uses hardcoded offsets to find the taskstats struct members.
> This got changed in 2.6.37 so it now iotop doesn't work on amd64.  The
> offending commit is:
> 
> commit 85893120699f8bae8caa12a8ee18ab5fceac978e
> Author: Jeff Mahoney <jeffm@suse.com>
> Date:   Wed Oct 27 15:34:43 2010 -0700
> 
>     delayacct: align to 8 byte boundary on 64-bit systems
> 
> Brian Rogers gets the reported-by tag.  The bugzilla entry is:
> https://bugzilla.kernel.org/show_bug.cgi?id=24272
>

Thanks for the report, looks like the change did not even bump the
version field. Sorry, its my fault, I should have caught it earlier.
iotop hard coding member offsets is not bad as long as we don't break
ABI (expected from us). Any chance you could dump the offsets before
and after the change?

-- 
	Three Cheers,
	Balbir
