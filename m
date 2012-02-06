Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab2BFVTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:19:30 -0500
Received: from longford.logfs.org ([213.229.74.203]:35652 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2BFVT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:19:29 -0500
X-Greylist: delayed 2201 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Feb 2012 16:19:28 EST
Date: Mon, 6 Feb 2012 14:02:06 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Joel Becker <jlbec@evilplan.org>
Subject: Announce: cancd 0.2.0 netconsole capture server
Message-ID: <20120206190206.GA8068@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Documentation/networking/netconsole.txt:
	The remote host can run either 'netcat -u -l -p <port>',
	'nc -l -u <port>' or syslogd.

Now, both of these options have their issues.  Netcat works fine, but
only reasonably scales to 1.  Having to use a seperate port for every
test machine, as well as a seperate netcat process that writes to a
proper file becomes a bit of a nightmare by the time you approach
three digits of machines.

Syslogd would be great, if netconsole actually spoke syslog protocol.
As it is netconsole speaks a protocol I would describe as "7bit ascii,
no nonsense".  Syslog protocal is described in rfc5424, a 38-page
document.  I think it is fair to say the two are incompatibel.  In
case someone actually wants to see the full trainwreck, a quick search
should come up with enough bug reports to scare your children into
bed.

Given that sad state of things, here is yet another alternative:
http://git.kernel.org/?p=linux/kernel/git/joern/cancd.git

It is far from perfect.  Bases on cancd 0.1.0, written by Joel Becker,
it is completely incompatible to the older version.  I decided to just
bang on the code long enough until it happened to do what I wanted.
No thought went into preserving previous functionality that I didn't
want to use.  No thought went into making functionality I did actually
want optional.  So unless your taste and requirements closely match
mine, you will have to invest some work.

The good new is that you have the source and can do it, just like I
did it.  If you send me patches that keep things working for me, I
will be happy to merge them.  If someone else wants to become
maintainer, great!  Less work for me.

Also beware that I changed the code, but not the documentation.  Oh,
Joel also disagrees with a number of the changes I made.  A better
programmer with more time could have kept 0.1.0 and 0.2.0 compatible.
I didn't, sorry.

Jörn

PS: Since there is no documentation, here is a quick overview.

Invocations: cancd -p <port> -l <log_dir>

Cancd will take any messages thrown at that port, prepend a timestamp
to each line and write them out to a logfile matching the "machine".
Initially, the logfile will be the IP address of the source host.  If
that IP has a matching reverse DNS entry, the logfile will be "foo"
for "foo.example.org".  If you have two seperate machines
foo.a.example.org and foo.b.example.org, they will use the same
logfile.

Best used in combination with logrotate, for obvious reasons.
