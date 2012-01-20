Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2ATRMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:12:08 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57450 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754219Ab2ATRMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:12:06 -0500
Message-ID: <1327079524.1753.5.camel@joe2Laptop>
Subject: Re: [PATCH 1/6] staging:android_pmem.h: Fixes the space and other
 formating issues pointed out by checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andy Whitcroft <apw@canonical.com>, swetland@google.com,
        Pradheep Shrinivasan <pradheep.sh@gmail.com>,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Date: Fri, 20 Jan 2012 09:12:04 -0800
In-Reply-To: <20120120134604.GM3356@mwanda>
References: <1326856764-2531-1-git-send-email-pradheep.sh@gmail.com>
	 <20120118065620.GE3294@mwanda>
	 <CANz8tm1imZ3njy_uV0tkq0sXwyB5ZLLJsrp4G1zjcBDnJUrjiw@mail.gmail.com>
	 <20120118185457.GH3356@mwanda>
	 <CAAq6er0OPkvTCLt1DvHSjyqM4pH7GMb-D78M09cJY+1ZV3miiQ@mail.gmail.com>
	 <1327065315.6176.24.camel@joe2Laptop> <20120120134604.GM3356@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-20 at 16:46 +0300, Dan Carpenter wrote:
> On Fri, Jan 20, 2012 at 05:15:15AM -0800, Joe Perches wrote:
> > @@ -2838,7 +2849,8 @@
> >                         if ($dstat ne '' &&
> >                             $dstat !~ /^(?:$Ident|-?$Constant),$/ &&                    # 10, // foo(),
> >                             $dstat !~ /^(?:$Ident|-?$Constant);$/ &&                    # foo();
> > -                           $dstat !~ /^(?:$Ident|-?$Constant)$/ &&                     # 10 // foo()
> > +                           $dstat !~ /^[!~-]?(?:$Ident|$Constant)$/ &&         # 10 // foo() // !foo // ~foo // -foo
> > +                           $dstat !~ /^'X'$/ &&                                        # character constants
> >                             $dstat !~ /$exceptions/ &&
> >                             $dstat !~ /^\.$Ident\s*=/ &&                                # .foo =
> >                             $dstat !~ /^do\s*$Constant\s*while\s*$Constant;?$/ &&       # do {...} while (...); // do {...} while (...)
> > I think the character change test is fine but
> > the !~- addition/change is suspect.
> > !~- are precedence level 3 operators
> Level 2?

Table I looked at said 3,
http://publib.boulder.ibm.com/infocenter/macxhelp/v6v81/index.jsp?topic=/com.ibm.vacpp6m.doc/language/ref/clrc05preeval.htm
but 1 is c++ only, so you're right
c level 2.

> Anyway if people are really writing macros which are used this way,
> then that's something which is outside of the scope of checkpatch.pl
> to fix.

I think there are some convenience macros like:
#define helper(a, b) some->long[a]->dereference.b

but likely anyone that really wants to add a
!~- prefix to those should be mindful anyway.

