Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab1GAOex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:34:53 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55685 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756694Ab1GAOew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:34:52 -0400
Subject: Re: [PATCH v7 00/16] EVM
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>
In-Reply-To: <BANLkTin-x1kkXiowUYjBS_tr4iwDrzNQkA@mail.gmail.com>
References: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <BANLkTinSsqBqX7=jzwbw_=RfXeQz29h_+A@mail.gmail.com>
	 <1309390941.3205.22.camel@localhost.localdomain>
	 <BANLkTineYVKw9MMQUqRGJ6Q_yEfgmsgJxg@mail.gmail.com>
	 <1309405895.3205.57.camel@localhost.localdomain>
	 <BANLkTin-x1kkXiowUYjBS_tr4iwDrzNQkA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 10:34:33 -0400
Message-ID: <1309530873.3245.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 18:31 -0400, Kyle Moffett wrote:

> The problem is that you are assuming that a large chunk of filesystem
> code is capable of properly and securely handling untrusted and
> malicious
> content.  Historically filesystem drivers are NOT capable of handling
> such things, as evidenced by the large number of bugs that tools such
> as
> fsfuzzer tend to trigger.  If you want to use IMA as-designed then you
> need to perform a relatively extensive audit of filesystem and fsck
> code.
> 
> Furthermore, even when the filesystem does not have any security
> issues
> itself, you are assuming that intentionally malicious data-aliasing
> between "trusted" and "untrusted" files can have no potential security
> implications.  You should look at the prevalence of simple stupid
> "/tmp"
> symlink attacks for more counter-examples there.
> 
> In addition, IMA relies on the underlying attribute and data caching
> properties of the VFS, which won't hold true for intentionally
> malicious
> corrupted filesystems.  It effectively assumes that writing data or
> metadata for one file will not invalidate the cached data or metadata
> for
> another which is blatantly false when filesystem extents overlap each
> other.
> 
> Overall, the IMA architecture assumes that if it loads and validates
> the
> file data or metadata that it cannot be changed except through a
> kernel
> access to that particular inode.  For a corrupted filesystem that is
> absolutely untrue.
> 
> Cheers,
> Kyle Moffett

You've brought up a number of interesting scenarios, which I appreciate.
I will definitely take a closer look at fsfuzzer. It might be a good
starting point for an EVM/IMA-appraisal LTP testsuite. The bottom line,
as I said previously, is that EVM/IMA-appraisal doesn't need to prevent
these things from occurring.  It just needs to be able to detect them.
Caching the integrity verification results is a performance issue, be it
an important one.

Currently the integrity verification results are reset when the file
data or metadata changes and removed on __fput().  Based on your
scenarios, I am looking to see if there might be additional situations
where the verification results need to be reset.

thanks,

Mimi

