Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2ATNPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:15:21 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36813 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751808Ab2ATNPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:15:18 -0500
Message-ID: <1327065315.6176.24.camel@joe2Laptop>
Subject: Re: [PATCH 1/6] staging:android_pmem.h: Fixes the space and other
 formating issues pointed out by checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        swetland@google.com, devel@linuxdriverproject.org,
        Pradheep Shrinivasan <pradheep.sh@gmail.com>
Date: Fri, 20 Jan 2012 05:15:15 -0800
In-Reply-To: <CAAq6er0OPkvTCLt1DvHSjyqM4pH7GMb-D78M09cJY+1ZV3miiQ@mail.gmail.com>
References: <1326856764-2531-1-git-send-email-pradheep.sh@gmail.com>
	 <20120118065620.GE3294@mwanda>
	 <CANz8tm1imZ3njy_uV0tkq0sXwyB5ZLLJsrp4G1zjcBDnJUrjiw@mail.gmail.com>
	 <20120118185457.GH3356@mwanda>
	 <CAAq6er0OPkvTCLt1DvHSjyqM4pH7GMb-D78M09cJY+1ZV3miiQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-20 at 11:12 +0000, Andy Whitcroft wrote:
> On Wed, Jan 18, 2012 at 6:54 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Wed, Jan 18, 2012 at 11:38:34PM +0530, Pradheep Shrinivasan wrote:
> >>> > > -#define PMEM_IOCTL_MAGIC 'p'
> >> > > +#define PMEM_IOCTL_MAGIC ('p')
> >> > You don't need parenthesis here.  Did checkpatch really complain
> >> > about this?
> >> Yes the check patch does complain about the parenthesis.
> > That seems like a bug in checkpatch.pl.  It's hard to imagine less
> > complex macro than:  #define PMEM_IOCTL_MAGIC 'p'
> I can think of no way in which an unprotected character is different
> to an unprotected integer constant.  So ...
> Does the version here work better for you:
>     http://people.canonical.com/~apw/checkpatch/checkpatch-next.pl

diff here is:

@@ -2838,7 +2849,8 @@
                        if ($dstat ne '' &&
                            $dstat !~ /^(?:$Ident|-?$Constant),$/ &&                    # 10, // foo(),
                            $dstat !~ /^(?:$Ident|-?$Constant);$/ &&                    # foo();
-                           $dstat !~ /^(?:$Ident|-?$Constant)$/ &&                     # 10 // foo()
+                           $dstat !~ /^[!~-]?(?:$Ident|$Constant)$/ &&         # 10 // foo() // !foo // ~foo // -foo
+                           $dstat !~ /^'X'$/ &&                                        # character constants
                            $dstat !~ /$exceptions/ &&
                            $dstat !~ /^\.$Ident\s*=/ &&                                # .foo =
                            $dstat !~ /^do\s*$Constant\s*while\s*$Constant;?$/ &&       # do {...} while (...); // do {...} while (...)

I think the character change test is fine but
the !~- addition/change is suspect.

!~- are precedence level 3 operators
and can be impacted by things like ++
and function calls.

