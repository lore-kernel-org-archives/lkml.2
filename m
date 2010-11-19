Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab0KSVSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:18:39 -0500
Received: from p3plsmtpa01-06.prod.phx3.secureserver.net ([72.167.82.86]:42882
	"HELO p3plsmtpa01-06.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755339Ab0KSVSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:18:38 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 16:18:38 EST
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
From: Andy Walls <andy@silverblocksystems.net>
To: linux-kernel@vger.kernel.org
Cc: sarah.a.sharp@linux.intel.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 16:12:34 -0500
Message-ID: <1290201154.2116.29.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Fri, Nov 19, 2010 at 11:19 AM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
> >
> > .config and dmesg are attached.  The box is running klogd 1.5.5ubuntu3
> > (from Jaunty).  Yes, I know that's old.  I read the bit in the commit
> > about changing the permissions of kallsyms after boot, but if I can't
> > boot that doesn't help.  Perhaps this can be made a configuration
> > option?
> 
> It's not worth a config option.
> 
> If it actually breaks user-space, I think we should just revert it.

User space klogd is what's broken in this case:

        ksyms = fopen(KSYMS, "r");

        if ( ksyms == NULL )
        {
                if ( errno == ENOENT )
                        Syslog(LOG_INFO, "No module symbols loaded - "
                               "kernel modules not enabled.\n");
                else
                        Syslog(LOG_ERR, "Error loading kernel symbols " \
                               "- %s\n", strerror(errno));
                fclose(ksyms);
                return(0);
        }

The fclose(NULL) is a bug, as I don't think the standards require
that to be handled gracefully.


> It's kind of sad to default to the world-visible thing,

klogd also gets symbols from System.map, so /proc/kallsyms access
is not a strict requirement.

I haven't checked to see if klogd can work without a symbol source
at all, but I'll wager it can.

Regards,
Andy


