Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab0FDSr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 14:47:27 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44434 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab0FDSrZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 14:47:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ND50y00pGbTG0vpqlOEMsTAfT8iXOszhcFBM/ALFG4t6vqA1ebYhZxXkgpbS/W7ntM
         KL0Jjia2g1OoFTDymjxLlgLsRIOmiLzL2VEHOorw5JB7SHaZSd4TdJYp5oTliHLB1GI3
         zFI+Te5RRThv2Y4b9GhG8oGly4LJUv1c30DdE=
MIME-Version: 1.0
In-Reply-To: <1275664158.3205.27.camel@localhost.localdomain>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
	<alpine.LRH.2.00.1005311017530.24571@tundra.namei.org>
	<AANLkTil8LHjRT_PMosymmtBb1pxIzkBaWC0ef35DCBUU@mail.gmail.com>
	<AANLkTil7WvVZ-3zpA0E--fUcHTqul3pnXnPm1xXn_vlH@mail.gmail.com>
	<1275420536.28134.37.camel@localhost.localdomain>
	<4C060224.4090601@nokia.com>
	<AANLkTikuXjWTEfYG2JLNW6znGGKNxzobw3ijCpG7u1xz@mail.gmail.com>
	<4C062092.2030608@nokia.com>
	<1275487340.3068.74.camel@localhost.localdomain>
	<AANLkTinIVaTocIgStpwKlXDByS7Z9t_OxJDYg0DoUMIN@mail.gmail.com>
	<1275664158.3205.27.camel@localhost.localdomain>
Date: Fri, 4 Jun 2010 23:47:24 +0500
Message-ID: <AANLkTik6Ww6zM2LaNzgX5TSGOaxnK-VLQNVP-D0dtVJi@mail.gmail.com>
Subject: Re: [PATCH 00/14] EVM
From: Shaz <shazalive@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
       James Morris <jmorris@namei.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       securityengineeringresearchgroup 
	<securityengineeringresearchgroup@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 8:09 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Fri, 2010-06-04 at 11:53 +0500, Shaz wrote:
>> > Yes, verifying one file containing the hashes would be faster than
>> > verifying individual hashes stored as extended attributes (xattrs), but
>> > this does not take into account that files on a running system are being

What if the sensitive files (binary or data) are compared with IMA
measurements after trusted boot or at anytime a stakeholder wants to?
The comparisons made with IMA will be the sha1 (or ....) of the files
stored in that one verification file. The stakeholder's key determines
which measurements can be compared by her (privacy protection and
confidentiality). Better use this key for an equivalence mechanism for
the factor of performance. The stakeholder's key as an identity can
help to make remote attestation more sensible as well. And here you
will be moving towards TCG MPWG standards .....

Combine this with SELinux or some RBAC mechanism and hopefully you
will get something closer to what MeeGo is trying to achieve. Consider
a trusted package manager with a registry sort of functionality for
files and it's owners and users and you've got a complete solution.

The worst part is that achieving performance is tough, while space is
not a serious issue.

>> > modified or added. On a small form factor, the number of files is
>> > limited, but would this scale well? In addition, what protects that one
>> > file containing all the hashes from being modified?  So, if you limit


-- 
Shaz
