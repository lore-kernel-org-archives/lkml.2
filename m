Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab1ESJYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:24:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230Ab1ESJYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:24:22 -0400
Subject: Re: [PATCH v5 13/21] evm: add evm_inode_post_init call in gfs2
From: Steven Whitehouse <swhiteho@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        linux-security-module@vger.kernl.org, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>, Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@redhat.com>
In-Reply-To: <1305766540.3304.44.camel@localhost.localdomain>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1305557115-15652-14-git-send-email-zohar@linux.vnet.ibm.com>
	 <1305559822.2855.14.camel@menhir>
	 <1305561051.2669.10.camel@localhost.localdomain>
	 <1305562469.2855.26.camel@menhir>
	 <1305563758.2669.26.camel@localhost.localdomain>
	 <1305568250.2669.47.camel@localhost.localdomain>
	 <1305568671.2855.31.camel@menhir>  <4DD16B96.7020907@schaufler-ca.com>
	 <1305571683.2669.90.camel@localhost.localdomain>
	 <4DD17A15.2060102@schaufler-ca.com>
	 <1305766540.3304.44.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 19 May 2011 10:25:29 +0100
Message-ID: <1305797129.2867.2.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2011-05-18 at 20:55 -0400, Mimi Zohar wrote:
> On Mon, 2011-05-16 at 12:25 -0700, Casey Schaufler wrote: 
> > On 5/16/2011 11:48 AM, Mimi Zohar wrote:
> > > On Mon, 2011-05-16 at 11:23 -0700, Casey Schaufler wrote:
> 
> > >> There is a very real possibility that multiple concurrent LSMs will
> > >> be supported before too long. Smack already uses multiple attributes
> > >> (SMACK64, SMACK64EXEC) on a file. Getting all the attributes in a
> > >> single call could result in an interface that requires parsing a
> > >> string argument, and we all know how popular those are. Introducing
> > >> an interface that we know isn't going to accommodate this upcoming
> > >> direction does not seem prudent.
> > > I would think that Smack would benefit from Steven's suggestion of
> > > returning an array of xattrs. Without his suggestion, I'm not sure how
> > > you are, or planning on, initializing multiple xattrs from a single LSM,
> > > unless of course you're not using security_inode_init_security().
> > 
> > The good news is that Smack has one required attribute. The others
> > are for special purposes and will usually be absent. It is easy to
> > imagine an LSM that always uses multiple attributes on a given file.
> > 
> > Yes, the array of xattr structures makes sense for any one LSM,
> > but there still needs to be the potential for multiple calls for
> > the multiple LSM case. I can't see that going away without a radical
> > LSM restructuring.
> > 
> > > Multiple LSMs calling security_inode_init_security() will be an issue
> > > for EVM, as EVM assumes there is a single LSM xattr on which to base the
> > > initial hmac.
> > 
> > That is far from the biggest issue with multiple LSMs, but is definitely
> > something to worry about.
> 
> Ok. After thinking about this a bit more, moving
> evm_inode_init_security() into security_inode_init_security() only works
> for the single LSM and EVM case, but not for the multiple LSMs and EVM
> case, as the 'stacker' would call each LSM's
> security_inode_iint_security().  Having the 'stacker' return an array of
> xattrs would make sense and, at the same time, resolve the EVM issue. In
> evm_inode_post_init_security(), EVM could then walk the list of xattrs.
> 
> Mimi
> 
> 
> 
That sounds like a reasonable solution to me,

Steve.


