Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab0FDU02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:26:28 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:37294 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab0FDU0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:26:24 -0400
Subject: Re: [ProbableSpam] Re: [PATCH 00/14] EVM
From: David Safford <safford@watson.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Shaz <shazalive@gmail.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       securityengineeringresearchgroup 
	<securityengineeringresearchgroup@googlegroups.com>
In-Reply-To: <alpine.LRH.2.00.1006041052450.1003@tundra.namei.org>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <alpine.LRH.2.00.1005311017530.24571@tundra.namei.org>
	 <AANLkTil8LHjRT_PMosymmtBb1pxIzkBaWC0ef35DCBUU@mail.gmail.com>
	 <AANLkTil7WvVZ-3zpA0E--fUcHTqul3pnXnPm1xXn_vlH@mail.gmail.com>
	 <1275420536.28134.37.camel@localhost.localdomain>
	 <alpine.LRH.2.00.1006041052450.1003@tundra.namei.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 04 Jun 2010 16:25:55 -0400
Message-ID: <1275683155.2644.91.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-6.fc13) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 10:57 +1000, James Morris wrote:
> On Tue, 1 Jun 2010, Mimi Zohar wrote:
> 
> > SELinux, Smack, Capabilities, and IMA all use extended attributes. The
> > purpose of EVM is to detect offline tampering of these security extended
> > attributes.
> 
> One issue mentioned to me off-list is that if EVM is only protecting 
> against offline attacks, why not just encrypt the entire volume ?
> 
> This would provide confidentiality and integrity protection for all data 
> and metadata, rather than just integrity for xattr metadata.

Software whole disk encryption is slower, and doesn't really provide
integrity protection. While there are encryption modes, such as
IAPM (Integrity Aware Parallelizable Mode) which can provide both
confidentially and integrity guarantees, they are hard to use for
random access devices. An example attack is replaying previously
valid encrypted blocks, to revert to a previous version with a known 
vulnerabiity. With EVM, these attacks can be defeated
efficiently with directory level binding. (This is on our TODO list).

With encryption in the hard disk, the performance is less of an issue,
but the integrity problem is still there. Plus, most systems don't
have the encrypting drives, and need a software solution.

dave
