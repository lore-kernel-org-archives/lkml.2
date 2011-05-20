Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab1ETM3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 08:29:16 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:43226 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1ETM3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 08:29:13 -0400
Subject: Re: [PATCH v5 03/21] evm: re-release
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20110519213754.GA10072@mail.hallyn.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1305557115-15652-4-git-send-email-zohar@linux.vnet.ibm.com>
	 <20110519213754.GA10072@mail.hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 08:29:05 -0400
Message-ID: <1305894545.3247.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 16:37 -0500, Serge E. Hallyn wrote: 
> Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> ...
> > +extern int evm_hmac_size;
> ...
> > +int evm_hmac_size = SHA1_DIGEST_SIZE;
> 
> I think I object to having both MAX_DIGEST_SIZE and evm_hmac_size, both
> of which are set to SHA1_DIGEST_SIZE throughout this patchset.  Especially
> because of the comment I was about to make on patch 4/21, where you
> then prepend the hmac with a 'type' byte, and start passing around
> MAX_DIGEST_SIZE+1 and evm_hmac_size+1.
> 
> Even if you're going to be using those differently in a later patchset,
> let's focus on this set for now and keep things simpler.  One constant
> for the hmac size, and then please define a new one (in patch 4) for
> the annotated digest size.  I can't think think of a good name.  Which
> suggests that perhaps you should define a nicely typed struct to contain
> the header+hmac...
> 
> I see no other problems, so presuming that these are nicely addressed
> I expect to happily ack.
> 
> thanks,
> -serge

Ok, MAX_DIGEST_SIZE was defined in the first patch of this patchset,
which moves the iint from IMA to integrity, but it seems to be
unnecessary for any of the additional EVM or IMA extensions, including
support for additional IMA hash sizes.  I'll remove MAX_DIGEST_SIZE.

The reason for introducing the extra byte at this point in the patch
set, as opposed to waiting to do so in the digital signature patches, is
to permit existing labeled systems to continue to run properly (and be
bisect safe).  Defining a structure is a good idea.

thanks,

Mimi

