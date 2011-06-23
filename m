Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545Ab1FWO1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:27:15 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:54794 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759530Ab1FWO1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:27:14 -0400
Date: Thu, 23 Jun 2011 10:27:06 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: yuyichao-mit <yuyichao@mit.edu>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Lars =?iso-8859-1?Q?T=E4uber?= <taeuber@bbaw.de>,
        linux-kernel@vger.kernel.org, linux-c-programming@vger.kernel.org
Subject: Re: extra slash in current path
Message-ID: <20110623142706.GA13310@elliptictech.com>
References: <BANLkTi=y1roManmZGMLBXSFbBVqK_KqDZg@mail.gmail.com>
 <20110623153116.404f2a63.taeuber@bbaw.de>
 <BANLkTinOb-4Xm_W2fmzivk6jBJwjeHYKVA@mail.gmail.com>
 <BANLkTimXH8K91cZ69oPRu=wbYt9JgBadfA@mail.gmail.com>
 <BANLkTin9bQ4hzs-odYU-Gxy-f-T+HLLAdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin9bQ4hzs-odYU-Gxy-f-T+HLLAdQ@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-23 10:11 -0400, yuyichao-mit wrote:
> On Thu, Jun 23, 2011 at 9:54 AM, richard -rw- weinberger
> > Is this really a kernel issue?
> > rw@raccoon:~> cd //
> > rw@raccoon://> pwd
> > //
> > rw@raccoon://> ls -l /proc/self/cwd
> > lrwxrwxrwx 1 rw users 0 23. Jun 15:53 /proc/self/cwd -> /
> 
> well, that's true, but this is indeed the retrun value of get_current_dir_name.

glibc's get_current_dir_name will honour the PWD environment variable in some
cases, which is where the // actually comes from (i.e., it does not come
from the kernel).

This funny behaviour of cd is actually specified by POSIX (man 1p cd):

        8. The curpath value shall then be converted to canonical form
           as follows, considering each component from beginning to
           end, in sequence:
[...]
            c. An implementation may further simplify curpath by
               removing any trailing slash characters that are not also
               leading slashes, replacing multiple non-leading
               consecutive slashes with a single slash, and replacing
               three or more leading slashes with a single slash.  If,
               as a result of this canonicalization, the curpath
               variable is null, no further steps shall be taken.

        9. [...] The PWD environment variable shall be set to curpath.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
