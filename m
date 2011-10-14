Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1JNIrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 04:47:53 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:47141 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab1JNIrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 04:47:51 -0400
Subject: Re: [PATCH] Fix strim() semantics for strings that have only blanks
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: andre.goddard@gmail.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20111013165431.b84ffab4.akpm@linux-foundation.org>
References: <1318408317.2891.3.camel@br98xy6r>
	 <20111013165431.b84ffab4.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 14 Oct 2011 10:44:17 +0200
Message-ID: <1318581857.3362.8.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Thu, 2011-10-13 at 16:54 -0700, Andrew Morton wrote:
> On Wed, 12 Oct 2011 10:31:57 +0200
> > Also strim() explicitly does not have "__must_check", in order to use it
> > without using the return value.
> > 
> 
> This observation seems to have nothing to do with the patch?

Well, it is just a hint that it was intentionally that the return value
of strim() can be ignored and therefore I legally can use it like I do
it ;-)

> I think that strim() _should_ have __must_check annotation (which means
> that strim() simply disappears, which is good).  It is only safe to
> ignore the strim() return value if the caller knows that the string
> started with a non-space.  The number of situations where this is
> guaranteed are faily small, I suspect.

Everywhere I use that function I know that my string has only trailing
blanks (or only blanks). Therefore I think we should have a function
that just removes trailing blanks. Perhaps we should change strim() to:

void strim(char *str);

And change the three users that need the return value to use the
strstrip() instead:

grep -r " = strim(" linux-2.6
security/apparmor/lib.c:	char *name = strim(fqname);
security/apparmor/lsm.c:	args = strim(args);
security/apparmor/policy.c:	hname = strim((char *)hname);

Michael

