Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab1FWObK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:31:10 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:41064 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab1FWObJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:31:09 -0400
Message-ID: <4E034E2A.1010100@msgid.tls.msk.ru>
Date: Thu, 23 Jun 2011 18:31:06 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: yuyichao-mit <yuyichao@mit.edu>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        =?ISO-8859-1?Q?Lars_T=E4uber?= <taeuber@bbaw.de>,
        linux-kernel@vger.kernel.org, linux-c-programming@vger.kernel.org
Subject: Re: extra slash in current path
References: <BANLkTi=y1roManmZGMLBXSFbBVqK_KqDZg@mail.gmail.com> <20110623153116.404f2a63.taeuber@bbaw.de> <BANLkTinOb-4Xm_W2fmzivk6jBJwjeHYKVA@mail.gmail.com> <BANLkTimXH8K91cZ69oPRu=wbYt9JgBadfA@mail.gmail.com> <BANLkTin9bQ4hzs-odYU-Gxy-f-T+HLLAdQ@mail.gmail.com>
In-Reply-To: <BANLkTin9bQ4hzs-odYU-Gxy-f-T+HLLAdQ@mail.gmail.com>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

23.06.2011 18:11, yuyichao-mit wrote:

>>>> $ cd //
>>>> $ pwd
>>>> //

The current directory is cached in $PWD environment
variable by shell (bash at least).  This variable is
checked in glibc (getcwd() et al) - if it is set and
stat($PWD) is the same as stat("."), that value is used.

It has nothing to do with kernel, probably the issue
is in bash which somehow allows double slash for root
dir (but not triple).

/mjt
